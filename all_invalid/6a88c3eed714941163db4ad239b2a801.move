//# publish
module 0x1::TestModule {
    // Struct for copying and modifying
    struct MyStruct has copy, drop {
        value: u64,
        flag: bool,
    }

    // Function to test local copy modification
    public fun copy_modify_test(mut s: MyStruct): u64 {
        let mut s_local = s; // copy
        // modify the local copy
        s_local.value = s_local.value + 100;
        // ensure original remains unchanged
        // return the local modified value
        s_local.value
    }

    // Function to return a field
    public fun get_flag(s: &MyStruct): bool {
        s.flag
    }

    // Function to test arithmetic literals
    public fun literal_tests(): bool {
        // numeric literals with underscores, leading zeros, hex
        let dec_with_underscores = 1_234_567u64;
        let leading_zero = 0000123u64; // leading zeros
        let hex_value = 0x1a2b3cu64;
        // compare
        dec_with_underscores == 1234567u64 &&
        leading_zero == 123u64 &&
        hex_value == 0x1a2b3c
    }

    // Two arg function: returns value if true, 0 if false
    public fun two_args(val: u64, flag: bool): u64 {
        if (flag) {
            val
        } else {
            0
        }
    }

    // Visibility test functions
    public fun public_func() {
        // do nothing
    }

    // Friend and private functions for access control testing
    friend(has access)
    fun friend_func() {
        // do nothing
    }

    private fun private_func() {
        // do nothing
    }

    // Function to test that modification affects original
    public fun modify_struct(s: &mut MyStruct): u64 acquires MyStruct {
        // modify field
        s.value = s.value + 10;
        s.value
    }
}

//# run 0x1::TestModule::copy_modify_test
// Use a signer to create and pass in a struct
//# run 0x1::TestModule::copy_modify_test --signers 0xABC --args 42u64  true
//# run 0x1::TestModule::get_flag --args 0x123::TestModule::MyStruct { value: 42, flag: true }

 //# run 0x1::TestModule::literal_tests

//# run 0x1::TestModule::two_args --signers 0xABC --args 100u64 true
//# run 0x1::TestModule::two_args --signers 0xABC --args 100u64 false

// Also test aborts with custom abort codes
module 0x1::AbortModule {
    // define custom abort codes
    const ERROR_CODE: u64 = 0x100;

    // Function that aborts with custom code
    public fun abort_with_code() {
        abort ERROR_CODE;
    }

    // Declare abort code
    public fun check_abort() {
        abort ERROR_CODE;
    }
}

// To test aborts, you can run:
//# run 0x1::AbortModule::abort_with_code --expect_abort 0x100
//# run 0x1::AbortModule::check_abort --expect_abort 0x100

// Test visibility modifiers
module 0x1::VisibilityTest {
    // public function accessible everywhere
    public fun publicly_accessible() {}

    // friend function accessible within the same module
    friend fun friend_function();

    // private function only accessible within this module
    fun private_only() {}

    // functions to test access
    public fun test_access() {
        // call public
        publicly_accessible();
        // call friend
        friend_function();
        // call private
        private_only();
    }
}

// In main test code, attempt to call private_only() from outside should fail (not added here as assertions are ignored)

// Note: For comprehensive testing, you could add more scripted calls, but as per instructions, focus is on core logic.