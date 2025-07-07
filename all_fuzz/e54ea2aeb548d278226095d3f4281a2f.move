
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let result = a + b;
            result
        };
        let output = lambda(5u8, 6u8);
        output
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        // This inline function calls a lambda inside LambdaTest
        let lambda_result = LambdaTest::run_lambda_example();
        let x = a + b;
        x + lambda_result
    }

    public fun caller(): u8 {
        let val = inline_add(10u8, 20u8);
        val
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_specific --args 3u8 4u8


//# run 0xCAFE::LambdaTest::run_lambda_example


//# run 0xCAFE::InlineCaller::caller


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b705033fbf3cb73d4bd53229d6f09878: Create let bindings with variable names, post-state information, and defining expressions.
