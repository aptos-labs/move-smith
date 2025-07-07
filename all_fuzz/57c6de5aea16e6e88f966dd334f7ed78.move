
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to distinguish returned value
        sum + 10
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(7, 8)
    }
}


//# run 0xCAFE::Addition::add_and_return_sum --args 5u8 11u8


//# run 0xCAFE::Addition::lambda_example



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Addition;

    public fun call_inline_lambda_and_additions(x: u8, y: u8): u8 {
        let sum1 = Addition::add_and_return_sum(x, y);
        let lambda: |u8, u8|u8 has copy + drop = |a: u8, b: u8| {
            a + b + 1
        };
        let sum2 = lambda(x, y);
        sum1 + sum2
    }
}

//# run 0xCAFE::NestedCalls::call_inline_lambda_and_additions --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
