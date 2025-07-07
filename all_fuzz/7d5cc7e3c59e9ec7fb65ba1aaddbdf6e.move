
//# publish
module 0xCAFE::Addition {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        adder(a, b)
    }
}


//# run 0xCAFE::Addition::add_u8 --args 5u8 6u8


//# run 0xCAFE::Addition::add_u8 --args 2u8 3u8


//# run 0xCAFE::Addition::with_lambda --args 8u8 1u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::Addition;

    public inline fun inline_add_twice(x: u8, y: u8): u8 {
        let first = Addition::add_u8(x, y);
        let second = Addition::add_u8(first, 1u8);
        second
    }

    public fun runner(): u8 {
        inline_add_twice(3u8, 4u8)
    }
}


//# run 0xCAFE::NestedInlineCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
