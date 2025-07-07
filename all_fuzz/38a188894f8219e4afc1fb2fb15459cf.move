
//# publish
module 0xCAFE::Computation {
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 1 to check correct addition and further computation
        sum + 1
    }

    public fun lambda_test(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(10u8, 5u8)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Computation::add_and_increment --args 3u8 4u8


//# run 0xCAFE::Computation::lambda_test


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Computation;

    public fun test_nested_inline_call(x: u8, y: u8): u8 {
        let intermediate = Computation::inline_adder(x, y);
        Computation::add_and_increment(intermediate, 1u8)
    }

    public fun call_lambda_directly(): u8 {
        Computation::lambda_test()
    }
}


//# run 0xCAFE::NestedCalls::test_nested_inline_call --args 2u8 3u8


//# run 0xCAFE::NestedCalls::call_lambda_directly


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
