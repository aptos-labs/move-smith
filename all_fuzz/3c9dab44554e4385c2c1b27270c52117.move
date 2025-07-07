
//# publish
module 0xCAFE::ComputeModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun run_lambda_example(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        add_lambda(7u8, 8u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::ComputeModule::add_two_values --args 3u8 5u8


//# run 0xCAFE::ComputeModule::add_two_values --args 7u8 8u8


//# run 0xCAFE::ComputeModule::run_lambda_example


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::ComputeModule;

    public fun call_inline_and_add(a: u8, b: u8, c: u8): u8 {
        let intermediate = ComputeModule::inline_add(a, b);
        ComputeModule::add_two_values(intermediate, c)
    }

    public fun no_arg_runner(): u8 {
        call_inline_and_add(3u8, 4u8, 5u8)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_add --args 2u8 3u8 4u8


//# run 0xCAFE::NestedCalls::no_arg_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
