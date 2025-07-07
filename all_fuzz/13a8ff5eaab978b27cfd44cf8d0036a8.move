
//# publish
module 0xCAFE::MathUtils {
    public inline fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun runner_add_two_u8(): u8 {
        let sum = add_two_u8(4u8, 6u8);
        assert!(sum == 10, 100);
        sum
    }

    public fun lambda_addition(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public fun lambda_runner(): u8 {
        let result = lambda_addition(7u8, 8u8);
        assert!(result == 15, 101);
        result
    }
}


//# run 0xCAFE::MathUtils::runner_add_two_u8


//# run 0xCAFE::MathUtils::lambda_runner


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathUtils;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let total = MathUtils::add_two_u8(a, b);
        total + 5u8
    }

    public fun runner_call_inline(): u8 {
        let result = call_inline_add(5u8, 3u8);
        assert!(result == 13, 200);
        result
    }
}


//# run 0xCAFE::CallerModule::runner_call_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
