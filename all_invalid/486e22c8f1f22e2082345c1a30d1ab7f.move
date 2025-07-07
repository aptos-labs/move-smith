//# publish
module 0xCAFE::TestModule {

    // Specification blocks are comments starting with spec
    // We will define a simple assert-like Spec for demonstration
    
    // Function to set up a global counter
    public fun initialize_counter() {
        move_to<Counter>(@0xCAFE, Counter { count: 0 });
    }

    // Function to increment counter
    public fun increment() {
        let counter_ref = borrow_global_mut<Counter>(@0xCAFE);
        counter_ref.count = counter_ref.count + 1;
    }

    // Function to get current counter value
    public fun get_counter(): u64 {
        let counter_ref = borrow_global<Counter>(@0xCAFE);
        counter_ref.count
    }

    // Removed invalid spec comments regarding subcommands
    // Instead, use inline comments or tooling annotations if supported
    
    //# run 0xCAFE::TestModule::initialize_counter --signers 0xCAFE
    //# run 0xCAFE::TestModule::increment --signers 0xCAFE
    //# run 0xCAFE::TestModule::get_counter --signers 0xCAFE

    // Additional test with types and arguments
    public fun generic_increment<T>(): T acquires T {
        // This is an intentionally generic function
        // For test, just returning default value
        // Expected to be called with T as u64
        let val: T = move(1 as T);
        val
    }

    //# run 0xCAFE::TestModule::generic_increment<u64> --signers 0xCAFE

    // Struct to test multiple members and resource capabilities
    struct DataHolder {
        value: u64,
        flag: bool,
    }

    public fun initialize_data_holder(): () {
        move_to<DataHolder>(@0xCAFE, DataHolder { value: 42, flag: true });
    }

    //# run 0xCAFE::TestModule::initialize_data_holder --signers 0xCAFE

    // Test to verify unpacking and member access
    public fun read_data_holder(): u64 {
        let dh_ref = borrow_global<DataHolder>(@0xCAFE);
        let val = dh_ref.value; // access member
        val
    }

    //# run 0xCAFE::TestModule::read_data_holder --signers 0xCAFE

}