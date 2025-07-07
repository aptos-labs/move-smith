
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to make result specific
        sum + 10
    }

    public fun test_lambda_usage(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        lambda(3u8, 4u8)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::TestAdd;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let incremented_a = inline_increment(a);
        let sum = TestAdd::add_and_return_sum(incremented_a, b);
        sum
    }
}


//# run 0xCAFE::TestAdd::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::TestAdd::test_lambda_usage


//# run 0xCAFE::NestedCalls::call_inline_and_add --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
