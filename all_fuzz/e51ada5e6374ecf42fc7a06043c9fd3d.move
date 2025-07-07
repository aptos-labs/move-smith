
//# publish
module 0xCAFE::AdditionLambda {
    // A simple module to test addition and lambdas

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed number ignoring sum to test computation before return
        42u8
    }

    public fun lambda_adder(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
}


//# run 0xCAFE::AdditionLambda::add_and_return_fixed --args 8u8 7u8


//# run 0xCAFE::AdditionLambda::lambda_adder --args 10u8 20u8


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AdditionLambda;

    public inline fun inline_double(a: u8): u8 {
        // Call inline function defined locally first
        a + 2
    }

    public fun call_nested_inline(a: u8, b: u8): u8 {
        // Call lambda_adder from AdditionLambda (computes sum a+b)
        let sum = AdditionLambda::lambda_adder(a, b);

        // Call local inline_double with the sum
        inline_double(sum)
    }

    public fun call_nested_inline_via_add_and_return_fixed(a: u8, b: u8): u8 {
        // Call AdditionLambda::add_and_return_fixed which computes addition but returns fixed result
        let _ = AdditionLambda::add_and_return_fixed(a, b);

        // Then call local inline_double with fixed number 42
        inline_double(42)
    }
}


//# run 0xCAFE::NestedInlineCaller::call_nested_inline --args 5u8 6u8


//# run 0xCAFE::NestedInlineCaller::call_nested_inline_via_add_and_return_fixed --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
