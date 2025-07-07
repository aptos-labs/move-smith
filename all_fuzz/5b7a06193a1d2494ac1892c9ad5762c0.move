
//# publish
module 0xCAFE::Calculator {
    public fun add_then_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 to test function logic
        42
    }

    public fun call_lambda_and_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda(x, y);
        sum
    }
}


//# run 0xCAFE::Calculator::add_then_fixed --args 10u8 15u8


//# run 0xCAFE::Calculator::call_lambda_and_add --args 7u8 8u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calculator;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // call call_lambda_and_add from Calculator
        Calculator::call_lambda_and_add(a, b)
    }

    public fun call_add_then_fixed(a: u8, b: u8): u8 {
        // call add_then_fixed from Calculator
        Calculator::add_then_fixed(a, b)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_add --args 20u8 22u8


//# run 0xCAFE::NestedCalls::call_add_then_fixed --args 30u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
