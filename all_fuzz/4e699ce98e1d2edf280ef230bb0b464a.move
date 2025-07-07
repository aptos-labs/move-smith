
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public fun runner(): u8 {
        use_lambda(4u8, 5u8)
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_special --args 7u8 5u8


//# run 0xCAFE::LambdaModule::add_and_return_special --args 2u8 3u8


//# run 0xCAFE::LambdaModule::use_lambda --args 6u8 7u8


//# run 0xCAFE::LambdaModule::runner



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public fun call_inline_add_and_return_special(a: u8, b: u8): u8 {
        LambdaModule::add_and_return_special(a, b)
    }

    public fun call_runner_multiple_times(): u8 {
        let r1 = LambdaModule::runner();
        let r2 = LambdaModule::runner();
        r1 + r2
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_add_and_return_special --args 8u8 4u8


//# run 0xCAFE::NestedCallModule::call_inline_add_and_return_special --args 3u8 2u8


//# run 0xCAFE::NestedCallModule::call_runner_multiple_times


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
