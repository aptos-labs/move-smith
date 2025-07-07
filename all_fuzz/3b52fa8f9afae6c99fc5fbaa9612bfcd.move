
//# publish
module 0xCAFE::LambdaAndInlineTest {
    // Module to test lambda expressions and inline functions together with spec pragmas and abort codes

    const ABORT_CODE: u64 = 1001;

    // Inline function to add two u8 numbers and return u8
    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }

    // Public function that uses the above inline function and checks result
    public fun compute_sum_and_check(a: u8, b: u8): u8 {
        let sum = add_inline(a, b);

        // spec block with pragma
        spec {
            pragma verify;
            assert!(sum == a + b, 0);
        };

        sum
    }

    // Public function with a lambda (anonymous function) expression
    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }

    // Runner function to combine calls and demonstrate in one flow
    public fun runner(): u8 {
        let val1 = use_lambda(10u8, 20u8);

        let val2 = compute_sum_and_check(val1, 5u8);

        val2
    }


    // expected_failure(abort_code(ABORT_CODE))]
    public fun fail_example() {
        abort(ABORT_CODE);
    }
}


//# run 0xCAFE::LambdaAndInlineTest::runner


//# run 0xCAFE::LambdaAndInlineTest::fail_example


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c1f37f0ad4f80bbc9489d5bb0e018ba2: Declare spec pragmas using the 'pragma' keyword within spec blocks.
// 317a9ccbb81811563d86e7b01a21b39a: Specify a specific abort code using `#[expected_failure(abort_code(...))]` attribute with a constant value or constant from the expected module.
