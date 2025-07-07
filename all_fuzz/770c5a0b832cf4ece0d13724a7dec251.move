
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        100u8 + sum
    }

    public fun lambda_add_and_multiply(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }

    public fun lambda_self_apply(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * 2u8
        };
        lambda(x)
    }
}


//# run 0xCAFE::AdditionModule::add_two_numbers --args 10u8 20u8


//# run 0xCAFE::AdditionModule::lambda_add_and_multiply --args 3u8 4u8


//# run 0xCAFE::AdditionModule::lambda_self_apply --args 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add_and_lambda(a: u8, b: u8): u8 {
        let val = AdditionModule::add_two_numbers(a, b);
        let (add, mul) = AdditionModule::lambda_add_and_multiply(a, b);
        val + add + mul
    }

    public fun runner(): u8 {
        call_inline_add_and_lambda(5u8, 6u8)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add_and_lambda --args 8u8 9u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
