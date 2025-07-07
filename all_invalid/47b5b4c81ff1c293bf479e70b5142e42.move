
//# publish
module 0xDEAD::FunctionTypeAndAbortTest {
    // You NEVER try to use this 0xDEAD::FunctionTypeAndAbortTest
    // It is only an example

    use std::signer;

    // Struct to hold a function pointer that takes a u8 and returns u8
    struct FuncHolder has copy, drop {
        func: |u8|u8,
    }

    // Function to return a function pointer as the result
    public fun get_identity_function(): |u8|u8 {
        |a: u8| a
    }

    // Function to test passing function as argument and executing it
    public fun execute_function(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // Function to intentionally abort execution
    public fun aborting_function(): u8 {
        abort 999;
    }

    // Function to test unreachable code after abort
    public fun test_unreachable(): u8 {
        abort 123;
        // The following code is intentionally unreachable
        let _ = 0;
        // The last expression should be discarded as unreachable
        abort 456;
    }

    // Runner function that covers the test cases
    public fun run_tests() {
        // Store a function pointer (identity)
        let identity_fn = get_identity_function();

        // Call execute_function with identity function
        let result1 = execute_function(identity_fn, 10);
        // Call execute_function with a lambda that adds 5
        let add_f = |a: u8| a + 5;
        let result2 = execute_function(add_f, 20);

        // Call the aborting function and catch the abort (this is just to include it in the test)
        // Note: in actual test environment, the abort will terminate the test unless caught by the VM
        // So this call is mainly illustrative
        // Normally, tests would expect aborts to occur, but since this is a compile and VM stress test, we include it
        // or comment it out if desired.

        // Uncomment the following line if the environment can handle aborts without terminating the test run
        // let _ = aborting_function();

        // Test unreachable code segment
        // The following call will abort and should be considered as testing bytecode dead code
        // Again, in real environment, this will stop execution
        // but for test purposes, we call it to ensure bytecode contains unreachable parts
        // to test the bytecode analysis and VM correctness.
        // Uncomment if your test runner can handle aborts and continues execution
        // let _ = test_unreachable();
    }
}


//# run 0xDEAD::FunctionTypeAndAbortTest::run_tests


// Featurres:
// 1acc13f6fd8a2090e6e29b86b2deaa8a: Return function types as the result of a function parameter.
// f1fe4e7d6c3ce19cc9f6ec8901785d45: Abort execution with the `abort` expression.
// 19ae64286d50498255dba95d60895376: Identify and highlight unreachable code segments in the bytecode.
