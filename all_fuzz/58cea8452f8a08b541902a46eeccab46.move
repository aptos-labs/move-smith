
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 3u8 7u8


//# publish
module 0xCAFE::LambdaTest {
    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun nested_lambda_call(): u8 {
        let outer = |v: u8| {
            let inner = |u: u8| u * 2;
            inner(v) + 5
        };
        outer(4)
    }
}


//# run 0xCAFE::LambdaTest::call_lambda --args 2u8 8u8


//# run 0xCAFE::LambdaTest::nested_lambda_call


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddAndReturn::add_and_return(a, b)
    }

    public fun calling_inline_function(x: u8, y: u8): u8 {
        inline_add(x, y)
    }
}


//# run 0xCAFE::InlineCaller::calling_inline_function --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
