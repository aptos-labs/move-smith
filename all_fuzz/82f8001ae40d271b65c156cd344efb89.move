
//# publish
module 0xCAFE::CalcModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 for testing purpose
        sum + 1
    }

    public fun lambda_example(x: u8): u8 {
        let add_two: |u8|u8 has copy+drop = |val: u8| {
            val + 2
        };
        add_two(x)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }
}


//# publish
module 0xCAFE::UseCalc {
    use 0xCAFE::CalcModule;

    public fun call_add_then_return_sum(a: u8, b: u8): u8 {
        CalcModule::add_then_return_sum(a, b)
    }

    public fun call_lambda_example(x: u8): u8 {
        CalcModule::lambda_example(x)
    }

    public fun call_inline_double_and_add(a: u8, b: u8): u8 {
        let doubled: u8 = CalcModule::inline_double(a);
        doubled + b
    }
}


//# run 0xCAFE::CalcModule::add_then_return_sum --args 10u8 20u8


//# run 0xCAFE::CalcModule::lambda_example --args 5u8


//# run 0xCAFE::UseCalc::call_add_then_return_sum --args 30u8 40u8


//# run 0xCAFE::UseCalc::call_lambda_example --args 7u8


//# run 0xCAFE::UseCalc::call_inline_double_and_add --args 4u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
