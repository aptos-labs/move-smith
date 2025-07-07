
//# publish
module 0xCAFE::AddAndReturn {
    // Test that a Move function correctly adds two u8 values and returns the sum plus a constant
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(a, b);
        result + 5
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun runner(): u8 {
        let val1 = add_and_return(3u8, 4u8);
        let val2 = add_with_lambda(5u8, 6u8);
        val1 + val2
    }
}


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AddAndReturn;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let sum1 = AddAndReturn::inline_add(a, b);
        AddAndReturn::inline_add(sum1, 10u8)
    }

    public fun call_runner_and_add_more(): u8 {
        let base = AddAndReturn::runner();
        base + 20
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 15u8


//# run 0xCAFE::AddAndReturn::add_with_lambda --args 7u8 8u8


//# run 0xCAFE::AddAndReturn::runner


//# run 0xCAFE::NestedInlineCall::call_inline_add --args 3u8 4u8


//# run 0xCAFE::NestedInlineCall::call_runner_and_add_more


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
