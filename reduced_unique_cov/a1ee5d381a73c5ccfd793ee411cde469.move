
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5u8
    }

    public fun call_lambda_and_return(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::TestAddition;

    public inline fun inline_sum(x: u8, y: u8): u8 {
        // Call a lambda inside here
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            TestAddition::add_and_return_sum(a, b)
        };
        lambda(x, y)
    }

    public fun call_inline_sum(x: u8, y: u8): u8 {
        inline_sum(x, y)
    }
}


//# run 0xCAFE::TestAddition::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::TestAddition::call_lambda_and_return --args 7u8 8u8


//# run 0xCAFE::InlineCaller::call_inline_sum --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
