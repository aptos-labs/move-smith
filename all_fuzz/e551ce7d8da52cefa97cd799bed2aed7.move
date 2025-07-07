
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // return fixed value 42u8 regardless of sum
        42u8
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        f(x, y)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    public fun call_inline_increment(x: u8): u8 {
        // nested call to inline function inside AddAndLambda
        let y = AddAndLambda::inline_increment(x);
        y
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_fixed --args 5u8 6u8


//# run 0xCAFE::AddAndLambda::lambda_test --args 10u8 20u8


//# run 0xCAFE::NestedCalls::call_inline_increment --args 41u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
