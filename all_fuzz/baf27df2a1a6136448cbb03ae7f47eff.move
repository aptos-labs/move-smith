
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return the sum directly
        sum
    }

    public fun run_addition_test(): u8 {
        // Use the add_and_return_sum with some constants
        add_and_return_sum(10u8, 15u8)
    }
}


//# run 0xCAFE::TestAddition::run_addition_test


//# publish
module 0xCAFE::TestLambda {
    public fun call_lambda_with_args(): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(7u8, 8u8)
    }

    public fun run_lambda_directly(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(100u8, 23u8)
    }
}


//# run 0xCAFE::TestLambda::call_lambda_with_args


//# run 0xCAFE::TestLambda::run_lambda_directly


//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAddition;

    public inline fun inline_compute(a: u8, b: u8): u8 {
        // Call an inline function in TestAddition indirectly through a separate function
        let result = inline_helper(a, b);
        result
    }

    public inline fun inline_helper(x: u8, y: u8): u8 {
        // call the add_and_return_sum in TestAddition
        TestAddition::add_and_return_sum(x, y)
    }

    public fun run_inline_call(): u8 {
        // call inline_compute which calls the inline helper which calls TestAddition
        inline_compute(20u8, 22u8)
    }
}


//# run 0xCAFE::TestInlineCall::run_inline_call


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
