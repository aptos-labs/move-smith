
//# publish
module 0xCAFE::MathFunctions {
    // Basic addition function for two u8 values that returns 42 plus their sum
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 42
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|(u8) has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::LambdaAndInlineCaller {
    use 0xCAFE::MathFunctions;

    public fun call_lambda(x: u8, y: u8): u8 {
        // Call the lambda test in MathFunctions module
        MathFunctions::test_lambda(x, y)
    }

    public fun call_inline_add_together(a: u8, b: u8, c: u8): u8 {
        // Call inline function twice and adds results
        let first = MathFunctions::inline_add(a, b);
        let second = MathFunctions::inline_add(b, c);
        first + second
    }
}


//# run 0xCAFE::MathFunctions::add_and_return_special --args 10u8 20u8


//# run 0xCAFE::MathFunctions::test_lambda --args 5u8 7u8


//# run 0xCAFE::LambdaAndInlineCaller::call_lambda --args 15u8 10u8


//# run 0xCAFE::LambdaAndInlineCaller::call_inline_add_together --args 1u8 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
