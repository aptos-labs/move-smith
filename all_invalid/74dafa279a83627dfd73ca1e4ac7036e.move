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
                i = i + 1; // Correctly assign to mutable i
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