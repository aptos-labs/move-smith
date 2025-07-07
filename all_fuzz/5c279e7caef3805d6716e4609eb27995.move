
//# publish
module 0xCAFE::MyModule {
    // Adding the missing inline function f2 so MathOps can call it
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::MathOps {
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 as a specific value to verify computation
        sum + 10
    }

    public fun call_inline_from_other_module(x: u16): (u16, u16) {
        // Calls the inline function from MyModule
        0xCAFE::MyModule::f2(x)
    }

    public fun run_assertion_check(x: u8) {
        // Assert the x is smaller than 100 or abort with code 999
        assert!(x < 100, 999);
    }

    public fun lambda_example(): u8 {
        let adder: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        let result = adder(6u8, 7u8);
        result
    }
}



//# run 0xCAFE::MathOps::add_and_return_specific --args 20u8 22u8



//# run 0xCAFE::MathOps::lambda_example



//# run 0xCAFE::MathOps::call_inline_from_other_module --args 15u16



//# run 0xCAFE::MathOps::run_assertion_check --args 42u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 904d5f7fb3dac9837ab65a2c61a8d8c6: Run specification checks on code.
