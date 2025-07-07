
//# publish
module 0xCAFE::TestModule {
    // The main test module
    use std::debug;

    // Helper function to simulate test
    public fun run_tests() {
        // Call foo with n = 0, expect 2
        let initial_result = Self::foo(0);
        // Call foo with n = 1, expect to be updated to 3
        let updated_result = Self::foo(1);
        // just to avoid unused variable warnings
        debug::print(&initial_result);
        debug::print(&updated_result);
    }

    // Function `foo` as per the description
    public fun foo(n: u8): u8 {
        // Initialize result to 2 if n == 0, else mutable variable
        if (n == 0) {
            2
        } else {
            let result = 2;
            let i: u8 = 0;
            while (i < n) {
                // update result to 3 in loop
                result = 3;
                i = i + 1;
            }
            result
        }
    }

    // Main function to run tests
    public fun start() {
        Self::run_tests();
    }
}


//# run 0xCAFE::TestModule::start


//# publish
module 0xCAFE::Friend {
    // Friend module to exercise friend declaration
    use std::debug;

    // Declare a friend to the TestModule
    friend 0xCAFE::TestModule;

    // Function accessible to friends
    public fun friend_access() {
        debug::print(&b"Friend access granted");
    }
}


//# run 0xCAFE::Friend::friend_access

// Featurres:
// df1dca05d1065dece7e545b57499f14c: Test that the function `foo` correctly returns initial value 2 when `n` is zero, and updates to 3 during the loop when `n` is one.
// e7c27353d8c26a6f11948b103983605b: Declare modules.
// 4a49c9340594b6ff9639bdd53f37a3f5: Include `friend` declarations in the module output.
