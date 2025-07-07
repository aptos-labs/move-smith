
//# publish
module 0xCAFE::AddAndLambda {
    public inline fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            add_two(p, q)
        };
        lambda(x, y)
    }

    public fun caller_of_inline(x: u8, y: u8): u8 {
        add_two(x, y)
    }

    public fun caller_of_lambda(x: u8, y: u8): u8 {
        with_lambda(x, y)
    }

    public fun runner(): u8 {
        let a = 10u8;
        let b = 20u8;
        caller_of_inline(a, b)
    }
}


//# run 0xCAFE::AddAndLambda::add_two --args 3u8 4u8


//# run 0xCAFE::AddAndLambda::with_lambda --args 5u8 6u8


//# run 0xCAFE::AddAndLambda::caller_of_inline --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::caller_of_lambda --args 9u8 10u8


//# run 0xCAFE::AddAndLambda::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
