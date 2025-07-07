
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // Always return 42 after computing sum
        42
    }

    public fun return_lambda(): |u8, u8|u8 {
        let sum_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        sum_lambda
    }
}


//# publish
module 0xCAFE::LambdaTestModule {
    public fun call_lambda_and_sum(x: u8, y: u8): u8 {
        let lambda = 0xCAFE::AdditionModule::return_lambda();
        let z = lambda(x, y);
        z + 1u8
    }

    public fun inline_2x_add(a: u16): u16 {
        (a + 1) + (a + 2)
    }

    // Call the inline function in this module
    public fun use_inline_function(a: u16): u16 {
        inline_2x_add(a)
    }
}


//# publish
module 0xCAFE::CrossModuleCallTest {
    use 0xCAFE::LambdaTestModule;

    public fun call_lambda_test_module(x: u8, y: u8): u8 {
        LambdaTestModule::call_lambda_and_sum(x, y)
    }

    public fun test_nested_inline_call(a: u16): u16 {
        LambdaTestModule::use_inline_function(a)
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_fixed --args 5u8 10u8


//# run 0xCAFE::AdditionModule::return_lambda


//# run 0xCAFE::LambdaTestModule::call_lambda_and_sum --args 3u8 4u8


//# run 0xCAFE::LambdaTestModule::use_inline_function --args 10u16


//# run 0xCAFE::CrossModuleCallTest::call_lambda_test_module --args 7u8 8u8


//# run 0xCAFE::CrossModuleCallTest::test_nested_inline_call --args 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
