//# publish
module 0xCAFE::ClosureTest {
    use std::signer;

    // Annotate variable coalescing by demonstrating multiple binds to the same lifetime variable
    // but define everything without mut and only let binding.
    struct Data has store {
        val: u8,
    }

    public fun create_data(v: u8): Data {
        Data { val: v }
    }

    /// Function taking a closure |u8|u8 and invoking it twice with different arguments
    public fun invoke_twice(f: |u8| u8, x: u8): (u8, u8) {
        let a = f(x);
        let b = f(x + 1);
        (a, b)
    }

    /// Function that accepts a closure with two u8 args and returns u8, calls it
    public fun invoke_with_two_args(f: |u8, u8| u8, x: u8, y: u8): u8 {
        f(x, y)
    }

    /// Runner function that creates a closure to increment and uses invoke_twice
    public fun runner_increment(): (u8, u8) {
        let inc = |a: u8| { a + 1 };
        invoke_twice(inc, 5)
    }

    /// Runner function that creates a closure multiplying two numbers, returns result of invoke_with_two_args
    public fun runner_multiply(): u8 {
        let mult = |a: u8, b: u8| { a * b };
        invoke_with_two_args(mult, 3, 7)
    }

    /// Function demonstrating variable coalescing annotation (dummy no-op)
    public fun var_coalescing_test(x: u8): u8 {
        let a = x;
        let b = a;
        let c = b;

        // Return last variable to test coalescing, some transformations should optimize this
        c
    }

    /// Function demonstrating closure with reference capturing (though Move closures do not capture env by ref,
    /// just demonstrate complex closure usage)
    public fun closure_captures(x: u8): u8 {
        let add_x = |a: u8| { a + x };
        add_x(10)
    }
}

//# run 0xCAFE::ClosureTest::runner_increment

//# run 0xCAFE::ClosureTest::runner_multiply

//# run 0xCAFE::ClosureTest::var_coalescing_test --args 42u8

//# run 0xCAFE::ClosureTest::closure_captures --args 100u8

// Test plan as a constant string for manual verification purposes

//# publish
module 0xCAFE::TestPlan {
    const PLAN: vector<u8> = b"Test plan for 0xCAFE::ClosureTest: 
    1) runner_increment: test closures as arguments and calling with one param
    2) runner_multiply: test closures with two params and call
    3) var_coalescing_test: test variable coalescing aliases without changing behavior
    4) closure_captures: test closures capturing environment variables properly";

    public fun get_plan() : &vector<u8> {
        &PLAN
    }
}

//# run 0xCAFE::TestPlan::get_plan

// Featurres:
// 168a5b22c5c6bf7b2999020e09cc62fe: Annotate variable coalescing transformations without changing the bytecode.
// 5e329af1abb77b9ee8a0a89f9ac15e7f: Create a test plan with module address, name, and collected test cases for testing purposes.
// 5d96c42efcae4498b0c987a603570c37: Test that functions accepting and invoking closures as arguments work correctly, including passing and calling closures with different parameter bindings.
