
//# publish
module 0xDEAD::NativeFunctionModule {
    // Testing native function declaration with and without bodies.
    // For the purposes of this test, native functions will be declared but not implemented.
    public fun native_no_body() acquires Drop;

    public fun native_with_body() acquires Drop;
}


//# run 0xDEAD::NativeFunctionModule::native_no_body


//# run 0xDEAD::NativeFunctionModule::native_with_body --args


//# publish
module 0xBADD::TestModule {
    use std::signer;
    use 0xCAFE::MyModule;

    // 1. Test native function declarations via explicit functions call.
    // These are dummy native functions; in actual tests, they would link to native code.
    public fun call_native_no_body() {
        // Trying to call the native with no body
        0xDEAD::NativeFunctionModule::native_no_body();
    }

    public fun call_native_with_body() {
        0xDEAD::NativeFunctionModule::native_with_body();
    }

    // 2. Verify move semantics and variable reassignment:
    // Declare variables x, y, and assign x to y, then update x, and verify x and y values.
    // Given Move semantics, after move, x should not be valid unless copied; but here, 
    // we assume we simulate move with copy (or mimic move behavior via explicit copying in test).
    // Note: In Move, simple variables like u64 are copyable; for references, move semantics apply.
    // We'll use u64 variables for this purpose.

    public fun test_move_and_update() {
        let x: u64 = 42;
        // move x into y; in Move, assigning a variable copies for copy types
        let y: u64 = x; // move is just copy for u64
        // update x
        let x = x + 1;
        let x_value = x;
        let y_value = y;
        // Verify that y retains original x value
        // (In Move, no runtime assert in test, but we simulate with assertions)
        assert!(x_value == 43, 999);
        assert!(y_value == 42, 999);
        // Further reassignment to x
        let x = x + 1; // x=44
        assert!(x == 44, 999);
        assert!(y == 42, 999);
    }

    // 3. Generate test plans for primary target modules.
    // (simulate by calling the functions in main/test context)
    public fun run_tests() {
        call_native_no_body();
        call_native_with_body();
        test_move_and_update();
    }
}


//# run 0xBADD::TestModule::run_tests --signers 0xBADD


// Featurres:
// 035dcc6afc2143ad24f0438dd6123c77: Declare native functions with or without a body in Move code.
// fbfb2e09c88a8f32245bce92297db02d: Verify that after moving the value of `x` into `y`, updating `x` does not affect `y`, and that `x` retains its updated value when used later.
// 381f4759ca362b7a031847e4ff1b5c66: Generate test plans for primary target modules when test code compilation is enabled.
