
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun lambda_example(x: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, 10u8)
    }

    public inline fun inline_add(a: u8, b:u8): u8 {
        a + b
    }

    public fun call_inline_nested(a: u8, b: u8): u8 {
        let inner = inline_add(a, b);
        inline_add(inner, 5u8)
    }

    public fun unused_var_and_param(_unused_param: u8) {
        let _unused_var = 123u8;
        // Function body intentionally empty
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 20u8 22u8


//# run 0xCAFE::AdditionModule::lambda_example --args 7u8


//# run 0xCAFE::AdditionModule::call_inline_nested --args 3u8 4u8


//# run 0xCAFE::AdditionModule::unused_var_and_param --args 0u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 5909ed0cbb657584f606bc62ef533156: Check for unused variables and parameters.
