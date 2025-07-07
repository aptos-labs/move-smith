
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    public fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    // Function with a lambda that multiplies and adds
    public fun lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            (a * b) + (a + b)
        };
        lambda(x, y)
    }

    // Runner without arguments for external run command
    public fun runner_add() {
        let _ = add_two_u8(10u8, 20u8);
    }

    public fun runner_lambda() {
        let _ = lambda_example(3u8, 4u8);
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    // Call inline function add_two_u8 from AddAndLambda module to add and then add 5 more
    public inline fun inline_add_and_more(x: u8, y: u8): u8 {
        let sum = AddAndLambda::add_two_u8(x, y);
        sum + 5u8
    }

    // call a function that nests inline function calls returning a u8
    public fun nested_call_runner(): u8 {
        let res = inline_add_and_more(2u8, 3u8);
        res
    }
}


//# run 0xCAFE::AddAndLambda::add_two_u8 --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 2u8 3u8


//# run 0xCAFE::AddAndLambda::runner_add


//# run 0xCAFE::AddAndLambda::runner_lambda


//# run 0xCAFE::NestedCalls::nested_call_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
