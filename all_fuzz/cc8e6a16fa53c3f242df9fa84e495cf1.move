
//# publish
module 0xCAFE::CalcModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            255u8
        } else {
            42u8
        }
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |n: u8| {
            n * 2
        };
        f(x)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_twice(x: u8): u8 {
        let y = inline_increment(x);
        inline_increment(y)
    }
}


//# run 0xCAFE::CalcModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::CalcModule::lambda_example --args 123u8


//# run 0xCAFE::CalcModule::call_inline_twice --args 10u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::CalcModule;

    public fun call_add_and_return_fixed_multiple(a: u8, b: u8): u8 {
        let result1 = CalcModule::add_and_return_fixed(a, b);
        let result2 = CalcModule::call_inline_twice(result1);
        result2
    }
}


//# run 0xCAFE::NestedCaller::call_add_and_return_fixed_multiple --args 40u8 50u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
