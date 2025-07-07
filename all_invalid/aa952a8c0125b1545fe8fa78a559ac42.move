
//# publish
module 0xBEEFBEEF::TestModule {
    use std::vector;

    struct Data has copy, drop, store, key {
        value: u64
    }

    public fun create_data(value: u64): Data {
        Data { value }
    }

    public fun aborting_function() {
        // This function will abort with code 999
        abort 999;
    }

    public fun test() {
        // Call nested aborts to test rollback
        aborting_function();
        // The following line should never be reached
        // but is added to test nested aborts (simulate through nested calls)
        abort 888;
    }

    public fun run_tests() {
        create_data(42);
        // Call test to trigger nested aborts
        test();
    }
}


//# run 0xBEEFBEEF::TestModule::run_tests --signers 0x00000000000000000000000000000000
