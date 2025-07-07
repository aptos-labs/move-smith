//# publish
module 0xDEADBEEF::TestModule {
    use std::debug;
    use std::option::{Option, some, none};

    // Spec block demonstrating top-level spec functions
    spec hello_world {
        // A simple spec that logs a message
        assert true;
    }

    // Resource with nested structs to test borrows
    struct Data with key {
        value: u64,
        nested: NestedStruct,
    }

    struct NestedStruct {
        info: u8,
        flag: bool,
    }

    // Function to initialize the resource
    public fun init_resource(account: &signer) {
        let data = Data {
            value: 42,
            nested: NestedStruct { info: 7, flag: true },
        };
        move_to(account, data);
    }

    // Function to read immutable borrows
    public fun read_borrows(account: &signer) acquires Data {
        let data_ref = borrow_global<Data>( Signer::address_of(account));
        debug::print(&data_ref.value);
        debug::print(data_ref.nested.info);
    }

    // Function to mutate data via mutable borrows
    public fun update_borrows(account: &signer) acquires Data {
        let data_ref_mut = borrow_global_mut<Data>( Signer::address_of(account));
        data_ref_mut.value = data_ref_mut.value + 1;

        // Mutate nested struct
        let nested_ref_mut = borrow_global_mut<NestedStruct>( Signer::address_of(account));
        nested_ref_mut.info = nested_ref_mut.info + 1;
    }

    // Function to demonstrate referencing immutable and mutable borrows
    public fun borrow_and_update(account: &signer) acquires Data {
        let data_ref = borrow_global<Data>( Signer::address_of(account));
        debug::print(&data_ref.value);
        debug::print(data_ref.nested.info);

        let data_ref_mut = borrow_global_mut<Data>( Signer::address_of(account));
        data_ref_mut.value = data_ref_mut.value + 10;

        let nested_ref_mut = borrow_global_mut<NestedStruct>( Signer::address_of(account));
        nested_ref_mut.info = nested_ref_mut.info + 10;
    }

    // Spec function to test expression linters configuration
    spec expression_linter_test {
        // Here we simulate configuration of linters, in practice this might be part of compiler options
        // For illustration only
        assert true;
    }

    //# run 0x1::TestModule::runner --signers 0x1
    public fun runner() {
        // For testing, assume account at 0x1
        // Initialize resource
        init_resource(&signer);
        // Read borrows
        read_borrows(&signer);
        // Update borrows
        update_borrows(&signer);
        // Borrow and mutate
        borrow_and_update(&signer);
    }
}