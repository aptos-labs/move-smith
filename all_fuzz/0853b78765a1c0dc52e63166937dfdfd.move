
//# publish
module 0xCAFE::MathModule {
    public inline fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = add_two_values(a, b);
        // Return 42 regardless the sum to verify function works
        42u8
    }

    public fun lambda_test(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}


//# run 0xCAFE::MathModule::add_and_return_specific --args 8u8 9u8


//# run 0xCAFE::MathModule::lambda_test --args 7u8 8u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun caller_add(a: u8, b: u8): u8 {
        MathModule::add_two_values(a, b)
    }

    public fun call_inline_and_lambda() {
        let inline_result = MathModule::add_two_values(10u8, 20u8);

        let double_lambda: |u8| u8 has copy+drop = |x: u8| { 
            x * 2 
        };

        let result_with_lambda = MathModule::add_two_values(inline_result, double_lambda(5u8));

        let _ = result_with_lambda;
    }

    public fun inline_with_closure_arg(x: u8, y: u8): u8 {
        let lambda_ignore_second: |u8, u8| u8 has copy+drop = |a: u8, _b: u8| {
            a * 3
        };
        lambda_ignore_second(x, y)
    }
}


//# run 0xCAFE::CallerModule::caller_add --args 15u8 27u8


//# run 0xCAFE::CallerModule::call_inline_and_lambda


//# run 0xCAFE::CallerModule::inline_with_closure_arg --args 7u8 99u8


//# publish
module 0xCAFE::AddrGroup {
    // Group related utilities or configs in single module
    const MAGIC: u64 = 0xDEADBEEF;
    public fun get_magic(): u64 {
        MAGIC
    }
}


//# run 0xCAFE::AddrGroup::get_magic


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 828d977b5d7b96456af4d7fd8c60f323: Test that inline functions can accept closures as arguments and properly handle closures with ignored parameters using underscores.
// 5458a922a618c11138df5a0fd46b7c67: Define Move modules grouped under a named address block for easier reuse and configuration.
