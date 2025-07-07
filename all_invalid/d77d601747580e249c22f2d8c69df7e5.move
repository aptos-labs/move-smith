
//# publish
module 0xBADD::TestModule {
    use std::signer;
    use std::vector;

    // Internal function, should be accessible within the module only
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    // Resource to test access control
    struct Data has key {
        value: u64,
        owner: address,
    }

    // Public function to create data resource
    public fun create_data(s: &signer, val: u64) {
        move_to(s, Data { value: val, owner: signer::address_of(s) });
    }

    // Internal function to modify data (simulate internal access)
    fun increment_data(addr: address) acquires Data {
        let data_ref: &mut Data = borrow_global_mut<Data>(addr);
        data_ref.value = data_ref.value + 10;
    }

    // Public function to call internal function, indirectly testing access
    public fun call_internal_increment(s: &signer) acquires Data {
        let addr = signer::address_of(s);
        increment_data(addr);
    }

    // Function that attempts to call internal add; testing internal access rule
    public fun call_internal_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }
}



//# run 0xBADD::TestModule::create_data --signers 0xC0FF --args 100


//# run 0xBADD::TestModule::call_internal_increment --signers 0xC0FF


//# run 0xBADD::TestModule::call_internal_add --args 42u64 58u64



//# publish
module 0xFEED::AccessControlTest {
    use std::signer;
    // Import the module with the correct address
    use 0xBADD::TestModule;

    // Resource to simulate multiple references to the same data
    struct SharedResource has key {
        data_ref: &mut TestModule::Data,
    }

    // Function to test variable shadowing and variable re-assignments in loops
    public fun variable_shadowing_test() {
        let outer_var = 5u64;

        let shadow_var = outer_var;
        let i = 0u64; // 'i' needs to be mutable to update
        while (i < 3) {
            let shadow_var = i; // shadowing outer shadow_var
            let _ = shadow_var;
            i = i + 1;
        };
        // At this point, shadow_var outside loop remains unchanged
        // Outer shadow_var should be 5
        assert!(shadow_var == 5, 111);
        assert!(i == 3, 222);
    }

    // Function to test variable references pointing to same resource
    public fun reference_behavior(s: &signer) acquires TestModule::Data {
        let addr = signer::address_of(s);
        // Create resource
        TestModule::create_data(s, 123);
        let data1: &mut TestModule::Data = borrow_global_mut<Data>(addr);
        let data2: &mut TestModule::Data = data1; // sharing reference
        data1.value = 200;
        // verify that data2 reflects the change
        assert!(data2.value == 200, 333);
    }

    // Function to test copy and reference semantics
    public fun copy_and_reference_test() {
        let val1 = 42u64;
        let val2 = val1; // copy
        // change val2 should not affect val1
        val2 = val2 + 10;
        assert!(val1 == 42, 444);
        assert!(val2 == 52, 555);
    }

    // Function to test access control with protected module
    public fun access_control_test(s: &signer) acquires TestModule::Data {
        // create data resource
        TestModule::create_data(s, 777);
        let addr = signer::address_of(s);
        // try to modify via protected function
        TestModule::call_internal_increment(s);
        // Borrow and check value
        let data_ref: &TestModule::Data = borrow_global<TestModule::Data>(addr);
        assert!(data_ref.value == 787, 666);
    }
}


// helper functions for borrow_global
fun borrow_global<DataType: copy + drop + store>(addr: address): &DataType {
    borrow_global<DataType>(addr)
}


//# run 0xFEED::AccessControlTest::variable_shadowing_test


//# run 0xFEED::AccessControlTest::reference_behavior --signers 0xABCD


//# run 0xFEED::AccessControlTest::copy_and_reference_test


//# run 0xFEED::AccessControlTest::access_control_test --signers 0xC0FF
