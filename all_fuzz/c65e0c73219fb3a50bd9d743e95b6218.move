
//# publish
module 0xCAFE::AddModule {
    // Module to test addition of two u8 values and returning a constant

    public fun add_and_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _const = 42u8;
        // Just to confirm sum is computed, dummy if-else
        if (sum > 0) {
            let _ = sum;
        } else {
            let _ = 0u8;
        };
        _const
    }

    public fun run_lambda_example(): u8 {
        let anon = |x: u8, y: u8| (x + y);
        let res = anon(10u8, 15u8);
        res
    }
}


//# run 0xCAFE::AddModule::add_and_return_const --args 10u8 32u8


//# run 0xCAFE::AddModule::run_lambda_example



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    // Calls inline function inside AddModule from here to verify nested call behavior

    public inline fun inline_sum(a: u8, b: u8): u8 {
        // Use anonymous function inline to add and then add 1
        let add = |x: u8, y: u8| (x + y);
        let base_sum = add(a, b);
        base_sum + 1u8
    }

    public fun call_add_and_return_const(a: u8, b: u8): u8 {
        AddModule::add_and_return_const(a, b)
    }

    public fun call_inline_sum(a: u8, b: u8): u8 {
        inline_sum(a, b)
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_return_const --args 5u8 7u8


//# run 0xCAFE::InlineCaller::call_inline_sum --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
