
//# publish
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

    // 2. Use of anonymous address: simulate using an address as a module name
    // Since Move does not support anonymous addresses directly, emulate as a module with a random address
    // For test purposes, create a module with a placeholder address
    
//# publish
    module 0xBAADBABE::AnonAddressModule {
        public fun fake_function(): u64 {
            42
        }
    }

    // 3. Declare a public(friend) function
    // Note: Move allows 'public(friend)', but for test, assuming it's accepted
    // The feature is not standard yet; here we simulate the syntax.
    public(friend) fun friend_only_function(): u64 {
        999
    }

    // Runner function to invoke the above functions for testing
    public fun run_all() {
        let result1 = use_lambda_in_function(10, 20);
        // Use the anonymous address module
        let v = 0xBAADBABE::AnonAddressModule::fake_function();
        // Access friend function
        let _ = friend_only_function();
    }
}


//# run 0xCAFE::LambdaAndFriendAccess::use_lambda_in_function --args 5u8 15u8

//# run 0xBAADBABE::AnonAddressModule::fake_function

//# run 0xCAFE::LambdaAndFriendAccess::run_all

// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// b1a5478458d80d8f31dc1be37b59075f: Use anonymous addresses as valid module or address names.
// acdaa6541ebd075c38b16fddc14104f1: Specify an item as publicly accessible to friends with 'public(friend)'.
