
//# publish
module 0xCAFE::CalcModule {
    // Module that provides arithmetic operations and lambdas

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returns sum + 1 just to exercise expression handling
        sum + 1
    }

    public fun lambda_double_then_add(x: u8, y: u8): u8 {
        let f: |u8|u8 has copy+drop = |z: u8| { z * 2 };
        let doubled = f(x);
        doubled + y
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun call_calculation(a: u8, b: u8): u8 {
        // Calls add_two_u8 in CalcModule and then applies inline_increment
        let sum = CalcModule::add_two_u8(a, b);
        let incremented = CalcModule::inline_increment(sum);
        incremented
    }

    public fun call_lambda_and_inline(x: u8, y: u8): u8 {
        let val = CalcModule::lambda_double_then_add(x, y);
        let val_inc = CalcModule::inline_increment(val);
        val_inc
    }
}


//# run 0xCAFE::CalcModule::add_two_u8 --args 4u8 5u8


//# run 0xCAFE::CalcModule::lambda_double_then_add --args 3u8 7u8


//# run 0xCAFE::CallerModule::call_calculation --args 4u8 5u8


//# run 0xCAFE::CallerModule::call_lambda_and_inline --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
