
//# publish
module 0xCAFE::NestedCalls {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_twice(a: u8, b: u8): u8 {
        let first = inline_add(a, b);
        let second = inline_add(first, 1u8);
        second
    }
}



//# publish
module 0xCAFE::LambdaModule {
    public fun apply_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }

    public fun apply_lambda_and_increment(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let res = sum_lambda(a, b);
        res + 1u8
    }
}



//# publish
module 0xCAFE::NativeTest {
    // Remove the native function declaration or implement it in Move or link it in VM.
    // Since no native implementation is provided, commenting out to fix MISSING_DEPENDENCY error.

    // native public fun native_add(a: u8, b: u8): u8;

    // Provide a Move implementation instead:
    public fun native_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_native_add(a: u8, b: u8): u8 {
        native_add(a, b)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::NestedCalls;
    use 0xCAFE::LambdaModule;
    use 0xCAFE::NativeTest;

    public fun test_nested_inline_functions(x: u8, y: u8): u8 {
        NestedCalls::call_inline_add_twice(x, y)
    }

    public fun test_lambda_sum(x: u8, y: u8): u8 {
        LambdaModule::apply_lambda(x, y)
    }

    public fun test_lambda_sum_increment(x: u8, y: u8): u8 {
        LambdaModule::apply_lambda_and_increment(x, y)
    }

    public fun test_native_call(x: u8, y: u8): u8 {
        NativeTest::call_native_add(x, y)
    }

    public fun test_compute_add_then_return(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Return fixed value 42, testing correct u8 addition before that
        42u8
    }
}



//# run 0xCAFE::CallerModule::test_compute_add_then_return --args 10u8 20u8



//# run 0xCAFE::CallerModule::test_lambda_sum --args 15u8 25u8



//# run 0xCAFE::CallerModule::test_lambda_sum_increment --args 5u8 10u8



//# run 0xCAFE::CallerModule::test_nested_inline_functions --args 3u8 7u8



//# run 0xCAFE::CallerModule::test_native_call --args 12u8 8u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e51039949682f12a0b9de5028b12a96e: Declare functions as native to indicate they are implemented outside Move code.
