
//# publish
module 0xCAFE::MathOps {
    public fun add_then_return_const(x: u8, y: u8): u8 {
        let sum = x + y;
        // Always return 42
        42
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::MathOps::add_then_return_const --args 10u8 20u8


//# run 0xCAFE::MathOps::use_lambda --args 11u8 31u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOps;

    public inline fun inline_add(x: u8, y: u8): (u8, u8) {
        let sum = x + y;
        (sum, sum + 1)
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let (a, b) = inline_add(x, y);
        let lambda: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            p + q
        };
        // calls lambda with result of inline_add tuple elements
        lambda(a, b)
    }

    public fun call_mathops_lambda(x: u8, y: u8): u8 {
        MathOps::use_lambda(x, y)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_lambda --args 5u8 10u8


//# run 0xCAFE::NestedCalls::call_mathops_lambda --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
