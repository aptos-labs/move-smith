
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return the sum + 5 to differentiate simple addition from this function return
        sum + 5
    }
}


//# run 0xCAFE::TestAdd::add_and_return_sum --args 3u8 4u8


//# publish
module 0xCAFE::TestLambda {
    public fun call_lambda_with_value(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }

    public fun call_lambda_multiple_times(x: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let temp = lambda(x, 1u8);
        lambda(temp, 2u8)
    }
}


//# run 0xCAFE::TestLambda::call_lambda_with_value --args 5u8


//# run 0xCAFE::TestLambda::call_lambda_multiple_times --args 3u8


//# publish
module 0xCAFE::TestInlineCall {
    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun nested_inline_call(x: u8): u8 {
        let y = 0xCAFE::TestInlineCall::inline_increment(x);
        let z = 0xCAFE::TestInlineCall::inline_increment(y);
        z
    }
}


//# run 0xCAFE::TestInlineCall::nested_inline_call --args 7u8


//# publish
module 0xCAFE::TestOrderEval {
    public fun mutate_and_sum(x: &mut u8, y: u8): u8 {
        // x is mutable reference, mutate it, then sum original y and new x value
        *x = *x + 2;
        *x + y
    }

    public fun complex_nested_calls(): u8 {
        let a = 1u8;
        let b = 3u8;

        // Call mutate_and_sum with a mutable reference to a and b
        let res1 = mutate_and_sum(&mut a, b);

        // Now do nested calls where arguments depend on mutation from previous calls
        let c = 4u8;
        let res2 = mutate_and_sum(&mut c, res1);

        // Final sum
        res1 + res2 + a + c
    }
}


//# run 0xCAFE::TestOrderEval::complex_nested_calls


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// ab4f2d8020a10dcc50efd93b1d2646fd: Test the order of evaluation and side effect sequencing of complex nested expressions with mutation and assignment in function arguments.
