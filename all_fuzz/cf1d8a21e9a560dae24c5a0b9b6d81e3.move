
//# publish
module 0xCAFE::MathOps {
    public fun add_and_return_sum_then_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        let incremented = sum + 1;
        incremented
    }

    public fun make_lambda() : |u8, u8|u8 has copy+drop {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda
    }

    public fun run_lambda_on_3_and_4() : u8 {
        let lambda = make_lambda();
        lambda(3u8, 4u8)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::MathOps::add_and_return_sum_then_increment --args 10u8 20u8


//# run 0xCAFE::MathOps::run_lambda_on_3_and_4


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOps;

    public fun call_inline_add_and_increment(x: u8, y: u8): u8 {
        let base_sum = MathOps::inline_add(x, y);
        base_sum + 1
    }

    public fun test_lambda_caller() : u8 {
        let lambda = MathOps::make_lambda();
        lambda(5u8, 10u8)
    }

    public fun runner() {
        let _a = call_inline_add_and_increment(1u8, 2u8);
        let _b = test_lambda_caller();
        
        // Just use the results, no assertion needed
    }
}


//# run 0xCAFE::NestedCalls::call_inline_add_and_increment --args 100u8 55u8


//# run 0xCAFE::NestedCalls::test_lambda_caller


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
