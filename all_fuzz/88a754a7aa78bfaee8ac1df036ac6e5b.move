
//# publish
module 0xCAFE::TestFeatures {
    /// Test 1: add two u8 then return constant u8
    public fun add_and_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum;
        42u8
    }

    /// Test 2: functions using lambdas (anonymous functions)
    public fun lambda_test_1(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        add(x, y)
    }

    public fun lambda_test_2(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        f(x)
    }

    /// Test 3: inline function f2 - replace external call since 0xCAFE::MyModule does not exist
    /// We'll define f2 here as an inline to simulate the original external call
    public inline fun f2(a: u16): (u16, u16) {
        (a / 2, a / 2)
    }

    public fun call_inline_from_other_module(a: u16): u16 {
        let (p, q) = f2(a);
        p + q
    }

    /// Test 4: conditional expressions, boolean logic and assertions
    public fun conditional_and_assert(x: u8, y: u8): u8 {
        let flag = (x < y) && (y < 100);
        let result = if (flag) { x + y } else { y - x };
        assert!(result > 0, 999);
        result
    }

    /// Test 5: return function type from function parameter
    public fun return_fn_type(f: |u8|u8, val: u8): |u8|u8 {
        let _ = val; // val unused, kept for parameter signature compatibility
        f
    }

    public fun runner_lambda_return_fn_type(): u8 {
        let double_fn: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        let returned_fn = return_fn_type(double_fn, 10u8);
        returned_fn(10u8)
    }
}



//# run 0xCAFE::TestFeatures::add_and_return_const --args 5u8 10u8


//# run 0xCAFE::TestFeatures::lambda_test_1 --args 6u8 7u8


//# run 0xCAFE::TestFeatures::lambda_test_2 --args 8u8


//# run 0xCAFE::TestFeatures::call_inline_from_other_module --args 100u16


//# run 0xCAFE::TestFeatures::conditional_and_assert --args 10u8 20u8


//# run 0xCAFE::TestFeatures::runner_lambda_return_fn_type
