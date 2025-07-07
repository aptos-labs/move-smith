
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // return a fixed value 42u8 ignoring sum, just testing computation and return
        42u8
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 32u8


//# run 0xCAFE::AddAndReturn::lambda_add --args 20u8 22u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturn;

    public inline fun call_inline_add_and_return(x: u8, y: u8): u8 {
        AddAndReturn::add_and_return(x, y)
    }

    public fun call_lambda_and_inline(x: u8, y: u8): u8 {
        let res_lambda = AddAndReturn::lambda_add(x, y);
        let res_inline = call_inline_add_and_return(x, y);
        // sum results modulo 256 (u8 addition)
        res_lambda + res_inline
    }

    public fun runner() {
        let _ = call_inline_add_and_return(5u8, 7u8);
        let _ = call_lambda_and_inline(3u8, 4u8);
    }
}


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
