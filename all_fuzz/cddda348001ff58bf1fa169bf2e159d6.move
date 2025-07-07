
//# publish
module 0xCAFE::AddModule {
    // Module to test addition of two u8 values and returning a specific value

    public fun add_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to have some computation after addition
        sum + 10
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun lambda_with_capture(a: u8): u8 {
        // A lambda that captures and adds one to input
        let x = 5u8;
        let lambda: |u8| u8 = |y: u8| {
            x + y
        };
        lambda(a)
    }
}


//# run 0xCAFE::AddModule::add_return_sum --args 3u8 4u8


//# run 0xCAFE::AddModule::use_lambda --args 7u8 8u8


//# run 0xCAFE::AddModule::lambda_with_capture --args 10u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_nested(a: u8, b: u8): u8 {
        let intermediate = AddModule::use_lambda(a, b);
        AddModule::add_return_sum(intermediate, 1u8)
    }

    public fun runner() {
        let _res1 = Self::call_inline_and_nested(2u8, 3u8);
        let _res2 = AddModule::add_return_sum(1u8, 1u8);
        let _res3 = AddModule::use_lambda(4u8, 5u8);
        let _res4 = AddModule::lambda_with_capture(6u8);
    }
}


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
