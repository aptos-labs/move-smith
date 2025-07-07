
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100
        } else {
            sum
        }
    }

    public fun lambda_example(): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        add(10u8, 20u8)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 40u8 50u8


//# run 0xCAFE::AddModule::add_two_values --args 60u8 50u8


//# run 0xCAFE::AddModule::lambda_example


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_function(a: u16): u16 {
        let (r1, r2) = AddModule_inline_call(a);
        r1 + r2
    }

    fun AddModule_inline_call(x: u16): (u16, u16) {
        AddModule::f2(x)
    }
}


//# run 0xCAFE::CallerModule::call_inline_function --args 10u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
