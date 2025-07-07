
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use std::option;

    // Function to test binding multiple typed variables simultaneously
    public fun test_binding_multiple() {
        let (num: u64, flag: bool, text: vector<u8>) = (42, true, b"hello");
        // Use the variables to prevent optimizer from removing them
        assert!(num == 42);
        assert!(flag);
        assert!(vector::length(&text) == 5);
    }

    // Function to test resolving addresses using named address
    public fun test_address_resolution() {
        // Assuming the alias 'Dev' maps to 0xCAFE in the project configs
        let dev_address = @0xCAFE;
        // Access some resource or perform an operation involving this address
        // For demonstration, just return the address
        dev_address;
    }

    // Function to iterate over list elements with custom termination condition
    public fun iterate_list_with_condition(list: vector<u64>) {
        let index = 0;
        let len = vector::length(&list);
        while (index < len) {
            let element = *vector::borrow(&list, index);
            // For demonstration, do something with element, e.g., assert it's within some range
            assert!(element <= 100);
            index = index + 1;
        }
    }
}



//# run 0xCAFE::TestModule::test_binding_multiple


//# run 0xCAFE::TestModule::test_address_resolution


//# run 0xCAFE::TestModule::iterate_list_with_condition --args  vector[u64]{1, 2, 3, 4, 5, 99}