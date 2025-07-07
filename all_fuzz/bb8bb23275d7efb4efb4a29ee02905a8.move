
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 100 to check computation is correct and result manipulation
        sum + 100
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * 2 + y
        };
        lambda(3, 4)
    }
}


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddAndReturn::add_and_return(a, b)
    }

    public fun nested_calls(): u8 {
        let x = inline_add(1, 2);
        let y = AddAndReturn::lambda_example();
        x + y
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 5u8 10u8


//# run 0xCAFE::AddAndReturn::lambda_example


//# run 0xCAFE::NestedInlineCall::nested_calls


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
