
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 1 to distinguish return value
        sum + 1
    }

    public fun use_lambda_addition(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Addition::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Addition::use_lambda_addition --args 15u8 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Addition;

    public fun call_inline_add_and_use_lambda(a: u8, b: u8): u8 {
        // Calls inline function from Addition module
        let sum = Addition::inline_add(a, b);

        // Uses lambda that uses Addition::inline_add internally
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            Addition::inline_add(x, y)
        };
        let lambda_sum = lambda(a, b);

        // return sum + lambda_sum to test nested calls
        sum + lambda_sum
    }
}


//# run 0xCAFE::NestedCall::call_inline_add_and_use_lambda --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
