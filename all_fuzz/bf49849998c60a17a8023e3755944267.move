
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to differentiate from simple sum
        sum + 10
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };

        lambda(a, b)
    }
}


//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAdd;

    public inline fun inline_add_plus(a: u8, b: u8): u8 {
        // Call the other module's add_and_return_sum and then add 5 to the result
        let res = TestAdd::add_and_return_sum(a, b);
        res + 5
    }

    public fun call_inline(a: u8, b: u8): u8 {
        inline_add_plus(a, b)
    }
}


//# run 0xCAFE::TestAdd::add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::TestAdd::call_lambda --args 8u8 9u8


//# run 0xCAFE::TestInlineCall::call_inline --args 2u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
