
//# publish
module 0xCAFE::InlineLambdaTest {
    use std::signer;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun lambda_adder(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        // call inline_add which just adds two u8 numbers
        inline_add(a, b)
    }

    public fun call_lambda_and_inline(x: u8, y: u8): u8 {
        let sum_lambda = lambda_adder(x, y);
        let sum_inline = call_inline_add(x, y);
        sum_lambda + sum_inline
    }

    public fun call_from_other_module(a: u8, b: u8): u8 {
        // call InlineLambdaTest.inline_add from another module or another function
        call_inline_add(a, b)
    }

    public fun runner(): u8 {
        let a = 5u8;
        let b = 6u8;
        let first_sum = call_inline_add(a, b);          // 11
        let lambda_sum = lambda_adder(a, b);            // 11
        let combined_sum = call_lambda_and_inline(a, b); // 22
        let from_other = call_from_other_module(a, b);  // 11
        first_sum + lambda_sum + combined_sum + from_other
    }
}


//# run 0xCAFE::InlineLambdaTest::runner


//# publish
module 0xCAFE::CallInlineFromOther {
    use 0xCAFE::InlineLambdaTest;

    public fun double_call(a: u8, b: u8): u8 {
        let first_call = InlineLambdaTest::inline_add(a, b);
        let second_call = InlineLambdaTest::lambda_adder(a, b);
        first_call + second_call
    }

    public fun runner(): u8 {
        double_call(10u8, 5u8)
    }
}


//# run 0xCAFE::CallInlineFromOther::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
