//# publish
module 0xCAFE::FriendModule {
    // This will be used in test to check duplicate friend module declarations
    // For testing duplicate, intentionally declare the same friend module twice
    // to cause a compiler error.
    // Uncomment the second line to see the error.
    // friend module 0xBABE;
    // friend module 0xBABE; // Intentionally duplicate to trigger compilation error

    // Declare a unique friend module
    friend module 0xDEAD::Helper;

    // Some functions for testing access
    public fun access_friend() acquires Helper {
        // Make a call to a function in the friend module
        0xDEAD::Helper::helper_function();
    }

    // A private function to test calling non-public functions
    fun private_helper() {
        // do nothing
    }
}

//# run 0xCAFE::FriendModule::access_friend --signers 0xCAFE

//# publish
module 0xCAFE::Helper {
    public fun helper_function() {
        // This function is called by FriendModule
        // It does nothing but can be used to verify access
    }

    // Additional function to test: function with return statement
    public fun return_example(x: u64): u64 {
        if (x > 10) {
            return x + 1;
        }
        // Control flow uses return to exit early
        let y = x * 2;
        return y;
    }
}

//# run 0xCAFE::Helper::helper_function --signers 0xCAFE
//# run 0xCAFE::Helper::return_example --signers 0xCAFE --args 5u64
//# run 0xCAFE::Helper::return_example --signers 0xCAFE --args 20u64

//# publish
module 0xCAFE::TestAccess {
    use 0xCAFE::FriendModule;

    // This function will attempt to call a non-public function for testing
    public fun test_non_public_call(): bool {
        // Trying to call a private function directly (should fail at compile time)
        // Uncommenting the line below should cause a compilation error
        // FriendModule::private_helper();
        // As per the instructions, do not actually call it; just note that it would fail
        false
    }
    
    // Function that calls an internal public function from FriendModule
    // Since FriendModule::access_friend() is public, calling it is allowed
    public fun run_access_test(): () {
        FriendModule::access_friend();
    }
}

//# run 0xCAFE::TestAccess::run_access_test --signers 0xCAFE