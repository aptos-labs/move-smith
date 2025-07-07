
//# publish
module 0xDEAD::NativeFunctionModule {
    // Declare native functions without bodies
    public fun native_no_body(): () acquires Drop;

    // Declare native function with body (possibly external)
    public fun native_with_body(): () acquires Drop;
}



//# run 0xDEAD::NativeFunctionModule::native_no_body



//# run 0xDEAD::NativeFunctionModule::native_with_body --args



//# publish
module 0xBADD::TestModule {
    use std::signer;
    // Removed the invalid or unbound use of 0xCAFE::MyModule to fix the error.
    // If needed, define or import the correct module instead.
    // use 0xCAFE::MyModule; // Commented out because it's invalid in current context.

    // 1. Test native function declarations via explicit function calls.
    public fun call_native_no_body() {
        // Assuming native functions are linked externally; direct invocation here.
        0xDEAD::NativeFunctionModule::native_no_body();
    }

    public fun call_native_with_body() {
        0xDEAD::NativeFunctionModule::native_with_body();
    }

    // 2. Verify move semantics and variable reassignment:
    // Declare variables x, y, and assign x to y, then update x
    public fun test_move_and_update() {
        let x: u64 = 42;
        // move x into y (for u64, copy semantics)
        let y: u64 = x;
        // update x
        let x = x + 1;
        let x_value = x;
        let y_value = y;
        // Verify y retains original x value
        assert!(x_value == 43, 999);
        assert!(y_value == 42, 999);
        // Further reassignment
        let x = x + 1; // x=44
        assert!(x == 44, 999);
        assert!(y == 42, 999);
    }

    // 3. Generate test plans for primary target modules.
    public fun run_tests() {
        call_native_no_body();
        call_native_with_body();
        test_move_and_update();
    }
}



//# run 0xBADD::TestModule::run_tests --signers 0xBADD
