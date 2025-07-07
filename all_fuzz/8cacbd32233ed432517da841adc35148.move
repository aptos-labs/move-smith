
//# publish
module 0xCAFE::Calc {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum; // do something with sum for clarity
        42u8
    }

    public fun lambda_example(x: u8): u8 {
        let double: |u8|u8 has copy+drop = |a: u8| a + a;
        double(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Calc::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::Calc::lambda_example --args 21u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Calc;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Call the inline function from Calc module
        Calc::inline_add(a, b)
    }

    public fun runner() {
        let _ = call_inline_add(100u8, 22u8);
    }
}


//# run 0xCAFE::NestedCall::call_inline_add --args 100u8 22u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
