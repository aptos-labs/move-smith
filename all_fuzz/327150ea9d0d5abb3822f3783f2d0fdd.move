
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value regardless of sum, to test function execution
        42u8
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}


//# run 0xCAFE::Arithmetic::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::Arithmetic::lambda_add --args 15u8 27u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Arithmetic;

    public inline fun call_inline_add_and_return(a: u8, b: u8): u8 {
        // Call the lambda_add function from Arithmetic module and add 1
        let val = Arithmetic::lambda_add(a, b);
        val + 1u8
    }

    public fun runner(): u8 {
        call_inline_add_and_return(5u8, 7u8)
    }
}


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
