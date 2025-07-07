//# publish
module 0xA550::test_module {
    /// Top-level spec block that defines functions for testing various features
    public fun run_all_tests() {
        // This function serves as a runner for all individual test cases
        // It calls other functions sequentially
        print_debug_info();
        test_literal_address_spec();
        test_friend_module_usage();
        test_phantom_type_parameters();
    }

    /// Function to log detailed debug information including bytecode dump name
    public fun print_debug_info() {
        // Enable debug logging if applicable (assuming the environment has such capability)
        // Here, we simulate debug info with a comment or placeholder
        // In actual environment, might invoke a debug log function
        // For illustration, do nothing
        // e.g., debug_log("Debug info: Bytecode dump for source: 'test_module.move'");
    }

    /// Test inclusion of a top-level spec block (demonstrated by defining a nested resource at the top level)
    // (Move doesn't support nested modules/scripts in the same file, but script and module are separate)
    // So, we simulate this with functions that conceptually act as spec blocks

    /// Function to declare and use a literal address specifier
    public fun test_literal_address_spec() {
        // Declare a literal address (simulate with a constant)
        let address_bytes = 0x1234u16;  // Using a 16-bit number to mimic a byte sequence
        // Since Move doesn't have a byte array literal, we can simulate by defining a constant
        // and then printing or using it in some way
        // For testing, perhaps just assign and assert
        // (no assertions as per the user instruction)
    }

    /// Function to demonstrate use of friend module
    public fun test_friend_module_usage() {
        // Call a function from a friend module to verify access
        // Assuming the friend module is declared below
        FriendModule::friend_function();
    }

    /// Function to demonstrate phantom type parameters
    public fun test_phantom_type_parameters() {
        // Instantiate a struct with phantom type parameters
        let _phantom_instance = PhantomStruct::<u64, bool> { phantom_0: core::marker::PhantomData, phantom_1: core::marker::PhantomData };
        // Access or just create the instance without using the type parameters
    }

    /// Struct with phantom type parameters to indicate unused generics
    struct PhantomStruct<T1, T2> {
        phantom_0: core::marker::PhantomData<T1>,
        phantom_1: core::marker::PhantomData<T2>,
    }
}

 //# publish
module 0xA550::FriendModule {
    /// Define a friend module
    // In Move, 'friend' has specific meaning for module friendship
    // For the purposes of this test, we'll declare a module that is considered a friend
    // and expose a function that is only accessible to friend modules
    public fun friend_function() {
        // Simulate some functionality that would be accessible to friends
        // For example, printing a message or performing an internal operation
        // Note: In Move, 'friend' modules are declared in the module attributes; here, just simulate
        // For illustration, do nothing
    }
}