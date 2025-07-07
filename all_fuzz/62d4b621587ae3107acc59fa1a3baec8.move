
//# publish
module 0xCAFE::Calculator {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        // Compute addition
        let sum = a + b;
        // Return fixed value 42 (test value)
        42u8
    }

    public fun lambda_operations(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| { x + y };
        let multiply_lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| { x * y };
        (add_lambda(a, b), multiply_lambda(a, b))
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public inline fun inline_call_nested(a: u8, b: u8): u8 {
        // call inline_add twice and sum results
        let ab = inline_add(a, b);
        let ba = inline_add(b, a);
        ab + ba
    }

    public fun multiple_use_of_return() {
        let x = inline_add(5u8, 7u8);
        let y = x * 2u8;
        let z = x + y;
        // z is last expression to return
        z
    }
}


//# run 0xCAFE::Calculator::add_and_return_fixed --args 3u8 4u8


//# run 0xCAFE::Calculator::lambda_operations --args 6u8 7u8


//# run 0xCAFE::Calculator::inline_call_nested --args 2u8 3u8


//# run 0xCAFE::Calculator::multiple_use_of_return


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2a06a5c3c4311fb5835a792534913bac: Test that values returned from a function are properly saved to locals and managed on the stack when they must be used multiple times in subsequent operations.
