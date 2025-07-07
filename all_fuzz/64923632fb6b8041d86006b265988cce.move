
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8
    }

    public fun test_lambda(): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(10u8, 32u8);
        result
    }
}


//# run 0xCAFE::TestAdd::add_and_return --args 5u8 6u8


//# run 0xCAFE::TestAdd::test_lambda



//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAdd;

    public inline fun inline_sum_call(a: u8, b: u8): u8 {
        let _ = TestAdd::add_and_return(a, b);
        let lambda_sum = TestAdd::test_lambda();
        a + b + lambda_sum
    }

    public fun runner(): u8 {
        inline_sum_call(5u8, 10u8)
    }
}


//# run 0xCAFE::TestInlineCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
