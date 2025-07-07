
//# publish
module 0xCAFE::TestLambda {
    // Test lambda expressions and u8 addition
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;

        let lambda: |u8|u8 has copy+drop = |a: u8| {
            let r = a + sum;
            r
        };
        lambda(1u8)
    }

    public fun no_arg_runner(): u8 {
        let add = |a: u8, b: u8| {
            let s = a + b;
            s
        };
        let res = add(5u8, 6u8);
        res
    }
}


//# run 0xCAFE::TestLambda::add_and_return --args 3u8 4u8


//# run 0xCAFE::TestLambda::no_arg_runner



//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestLambda;

    public inline fun inline_add(a: u8, b: u8): u8 {
        let res = a + b;
        res
    }

    public fun call_inline_add(x: u8, y: u8): u8 {
        // Call inline function within this module
        inline_add(x, y)
    }

    public fun call_other_module_inline(x: u8, y: u8): u8 {
        // Nested call to function in another module that uses lambda
        let partial = TestLambda::no_arg_runner();
        let sum = partial + x + y;
        sum
    }
}


//# run 0xCAFE::TestInlineCall::call_inline_add --args 10u8 20u8


//# run 0xCAFE::TestInlineCall::call_other_module_inline --args 1u8 2u8



//# publish
module 0xCAFE::ExpressionSequences {
    public fun sequence_test(x: u8): u8 {
        let a = x + 1;
        let b = a + 2;

        let _ = if (b > 10) {
            b - 1
        } else {
            b + 1
        };

        for (i in 0..3) {
            let _ = i * 2;
        };

        let c = 0;
        while (c < 5) {
            c = c + 1;
        };

        c
    }
}


//# run 0xCAFE::ExpressionSequences::sequence_test --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2230ad4e94f905080d70bad5d27034a7: Write sequences of expressions in your Move code
