//# publish
module 0xCAFE::DeprecationControl {
    // Using an environment variable to enable / disable deprecation warnings is usually outside Move's pure code,
    // but we simulate this by exposing a "flag" resource that can be set/unset to simulate the VM/compiler warning pass.
    // This module manages a boolean flag to simulate deprecation warnings enable/disable state.
    
    resource struct DeprecationFlag has store, key { enabled: bool }

    public fun publish_flag(account: &signer, enabled: bool) {
        move_to(account, DeprecationFlag { enabled });
    }

    public fun update_flag(account: &signer, enabled: bool) {
        let flag = borrow_global_mut<DeprecationFlag>(signer::address_of(account));
        flag.enabled = enabled;
    }

    public fun is_enabled(addr: address): bool acquires DeprecationFlag {
        if (exists<DeprecationFlag>(addr)) {
            let flag = borrow_global<DeprecationFlag>(addr);
            flag.enabled
        } else {
            false
        }
    }

    // Runner function to exercise setting and querying the flag under signer 0xCAFE
    public fun runner(account: &signer) {
        // Initially publish flag enabled
        publish_flag(account, true);
        let enabled = is_enabled(signer::address_of(account));
        // Disable it
        update_flag(account, false);
        let _disabled = is_enabled(signer::address_of(account));
        ()
    }
}
//# run 0xCAFE::DeprecationControl::runner --signers 0xCAFE

//# publish
module 0xCAFE::PrimaryModuleTest {
    // This module is a primary compilation target with a few members:
    // - struct with copy and drop abilities
    // - nested struct types
    // - functions that use arithmetic, bool, tuple unpacking.

    struct SimpleData has copy, drop, store {
        value: u64,
        flag: bool,
    }

    struct NestedData has store {
        sdata: SimpleData,
        counter: u8,
    }

    // Key is needed for top-level storage
    struct StoredData has copy, drop, store, key {
        inner: NestedData
    }

    public fun make_simple_data(v: u64, f: bool): SimpleData {
        SimpleData { value: v, flag: f }
    }

    public fun make_nested_data(v: u64, f: bool, c: u8): NestedData {
        let s = SimpleData { value: v, flag: f };
        NestedData { sdata: s, counter: c }
    }

    public fun create_stored_data(account: &signer, v: u64, f: bool, c: u8) {
        let nested = make_nested_data(v, f, c);
        let stored = StoredData { inner: nested };
        move_to(account, stored);
    }

    public fun update_stored_data(account: &signer) acquires StoredData {
        let addr = signer::address_of(account);
        let stored = borrow_global_mut<StoredData>(addr);

        // Do some arithmetic on u64 and u8, applying cast explicitly
        stored.inner.sdata.value = stored.inner.sdata.value + (10 as u64);
        stored.inner.counter = stored.inner.counter + (1 as u8);

        // Toggle flag
        stored.inner.sdata.flag = !stored.inner.sdata.flag;
    }

    public fun read_stored_data(addr: address): (u64, bool, u8) acquires StoredData {
        let stored = borrow_global<StoredData>(addr);
        let val = stored.inner.sdata.value;
        let flag = stored.inner.sdata.flag;
        let c = stored.inner.counter;
        (val, flag, c)
    }

    public fun runner(account: &signer) acquires StoredData {
        create_stored_data(account, 123, false, 7);
        update_stored_data(account);
        let (v, f, c) = read_stored_data(signer::address_of(account));
        // No assertions; just routine flow exercising struct, tuple unpacking and casting
        ()
    }
}
//# run 0xCAFE::PrimaryModuleTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::DeprecationControl;
    use 0xCAFE::PrimaryModuleTest;

    fun main(account: signer) {
        // Publish deprecation flag and toggle
        DeprecationControl::publish_flag(&account, true);
        let enabled1 = DeprecationControl::is_enabled(signer::address_of(&account));
        
        DeprecationControl::update_flag(&account, false);
        let enabled2 = DeprecationControl::is_enabled(signer::address_of(&account));

        // Create and update stored data from PrimaryModuleTest
        PrimaryModuleTest::create_stored_data(&account, 42, true, 2);
        PrimaryModuleTest::update_stored_data(&account);
        let (v, f, c) = PrimaryModuleTest::read_stored_data(signer::address_of(&account));

        ()
    }
}

// Featurres:
// cda46b10d41782eb13de043d803a0d78: Specify members to be included in the module by processing existing module information or adding new members.
// d7ed3a500e1dd4cda6c021401e5fdce3: Use an environment variable to enable or disable deprecation warnings during compilation
// 336076452978ed665784ddcf662dcede: Write tests for Move modules that are primary targets of compilation
