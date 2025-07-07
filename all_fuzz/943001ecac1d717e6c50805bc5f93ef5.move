
//# publish
module 0xCAFE::MathOps {
    public inline fun add(x: u8, y: u8): u8 {
        x + y
    }

    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = add(a, b);
        // return a fixed value 42 for testing purposes
        42u8
    }

    public fun with_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }

    public fun call_inline_from_another_module(a: u8, b: u8): u8 {
        0xCAFE::MathOps::add(a, b)
    }

    public fun test(): u8 {
        let a = 10u8;
        let b = 5u8;
        let c = a - b;
        let d = add(a, b);
        let e = a * b;
        let f = add(c, e);
        f
    }
}


//# run 0xCAFE::MathOps::add_and_return_42 --args 10u8 20u8


//# run 0xCAFE::MathOps::with_lambda --args 15u8


//# run 0xCAFE::MathOps::call_inline_from_another_module --args 7u8 8u8


//# run 0xCAFE::MathOps::test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// ba00d2a0082287cf64d197987fcd80c2: Test the `test` function to verify that it correctly performs arithmetic operations, including subtraction, addition, multiplication, and the use of the `add` helper function.
