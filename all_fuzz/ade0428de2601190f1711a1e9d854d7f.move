
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum plus a fixed offset to test computation
        sum + 10u8
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 5u8 10u8



//# publish
module 0xCAFE::LambdaFunctions {
    public fun call_lambda(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    public fun call_lambda_inside_lambda(x: u8, y: u8): u8 {
        let outer: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let inner: |u8| u8 has copy+drop = |z: u8| {
                a + b + z
            };
            inner(x)
        };
        outer(x, y)
    }
}


//# run 0xCAFE::LambdaFunctions::call_lambda --args 7u8 8u8


//# run 0xCAFE::LambdaFunctions::call_lambda_inside_lambda --args 3u8 4u8



//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_add_two(a: u8, b: u8): u8 {
        // call add_and_return from AddAndReturn module to test inline call and nesting
        AddAndReturn::add_and_return(a, b)
    }

    public fun run_test(): u8 {
        inline_add_two(10u8, 15u8)
    }
}


//# run 0xCAFE::InlineCall::run_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
