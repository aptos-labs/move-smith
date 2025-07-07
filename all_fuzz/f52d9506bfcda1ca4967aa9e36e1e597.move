
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            0u8
        }
    }

    public inline fun add_and_return_inline(a: u16): (u16, u16) {
        (a + 3, a + 7)
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_special --args 5u8 5u8



//# run 0xCAFE::AdditionModule::add_and_return_special --args 3u8 2u8





//# publish
module 0xCAFE::LambdaModule {
    public fun test_lambda_expression(): u8 {
        let lambda: |u8, u8| (u8) has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(6u8, 7u8)
    }

    public fun nested_lambdas(): (u8, u8) {
        let outer: |u8| (|u8|u8) has copy+drop = |x: u8| {
            let inner: |u8| u8 has copy+drop = |y: u8| { x + y };
            inner
        };
        let inner_lambda = outer(10u8);
        // Use the lambda only once without cloning to avoid use-after-move error
        let first = inner_lambda(2u8);
        // Recreate inner_lambda by calling outer(10u8) again
        let inner_lambda2 = outer(10u8);
        let second = inner_lambda2(5u8);
        (first, second)
    }
}



//# run 0xCAFE::LambdaModule::test_lambda_expression



//# run 0xCAFE::LambdaModule::nested_lambdas





//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add(a: u16): u16 {
        let (x, y) = inline_add(a);
        x + y
    }

    fun inline_add(a: u16): (u16, u16) {
        AdditionModule::add_and_return_inline(a)
    }
}



//# run 0xCAFE::CallerModule::call_inline_add --args 100u16





//# publish
module 0xCAFE::ShortCircuit {
    use std::error;

    fun error_func(): bool acquires error::Error {
        error::abort(100);
    }

    public fun test_or_short_circuit(): bool acquires error::Error {
        let left = true;
        // Because left is true, right side is not evaluated
        let right = error_func();
        left || right
    }

    public fun test_and_short_circuit(): bool acquires error::Error {
        let left = false;
        // Because left is false, right side is not evaluated
        let right = error_func();
        left && right
    }
}



//# run 0xCAFE::ShortCircuit::test_or_short_circuit



//# run 0xCAFE::ShortCircuit::test_and_short_circuit
