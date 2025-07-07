module 0xCAFE::LambdaAndFriendAccess {
    use std::vector;

    // 1. Function with lambda that captures a local variable
    public fun use_lambda_in_function(x: u8, y: u8): u8 {
        // Define a lambda that adds its argument with a captured variable
        let add_capture: |u8| u8 = |a: u8| {
            a + x
        };
        // Call the lambda with y
        add_capture(y)
    }

    // 2. Emulate an anonymous address: create a separate module with a placeholder address
    // Note: We cannot use anonymous addresses directly, so we define a dummy module with a fixed address.
    // The actual address is 0xBAADBABE for simulation.
    // Move does not support true anonymous addresses, so we keep the module as-is.
    module 0xBAADBABE::AnonAddressModule {
        public fun fake_function(): u64 {
            42
        }
    }

    // 3. Declare a public(friend) function
    // Note: Move syntax requires 'public(friend)' to be specified on the function itself,
    // but it should be within a module and not on a standalone function.
    // The syntax 'public(friend)' is accepted only inside a module, so we place it properly.
    // Additionally, move does not currently support 'public(friend)' in scripts,
    // so ensure this is placed inside the module.
    // The previous code tried to declare 'public(friend)' outside of a module, which is invalid.
    // Fix: Define the function inside a module or just mark as 'public' for test purposes.
    // For this test, let's define inside the main module with 'public(friend)' inline.

    // Since Move requires functions to be inside modules, and 'public(friend)' can only be on functions inside modules,
    // we need to encapsulate it properly.

    // Re-structure: move 'friend_only_function' into the main module with correct syntax

    // Instead, declare it directly here as a nested module:

    // Create a nested module for friend functions
    module FriendFunctions {
        // Declare the friend function inside this module
        // Use 'public(friend)' syntax
        public(friend) fun friend_only_function(): u64 {
            999
        }
    }

    // Runner function to invoke the above functions for testing
    public fun run_all() {
        let result1 = use_lambda_in_function(10, 20);
        // Use the anonymous address module
        let v = 0xBAADBABE::AnonAddressModule::fake_function();
        // Access friend function via nested module
        let _ = FriendFunctions::friend_only_function();
    }
}