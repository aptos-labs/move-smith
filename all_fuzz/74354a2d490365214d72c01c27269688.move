
//# publish
module 0xCAFE::Computation {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            100u8
        } else {
            sum
        }
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = add(a, b);
        result * 2u8
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Computation::add_and_return_special --args 4u8 6u8


//# run 0xCAFE::Computation::add_and_return_special --args 3u8 5u8


//# run 0xCAFE::Computation::with_lambda --args 2u8 3u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Computation;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Computation::inline_add(a, b)
    }

    public fun call_add_and_return_special(a: u8, b: u8): u8 {
        Computation::add_and_return_special(a, b)
    }

    public fun call_with_lambda(a: u8, b: u8): u8 {
        Computation::with_lambda(a, b)
    }

    public fun runner() {
        let _ = call_inline_add(7u8, 8u8);
        let _ = call_add_and_return_special(5u8, 5u8);
        let _ = call_with_lambda(4u8, 5u8);
    }
}


//# run 0xCAFE::Caller::call_inline_add --args 1u8 2u8


//# run 0xCAFE::Caller::call_add_and_return_special --args 5u8 5u8


//# run 0xCAFE::Caller::call_with_lambda --args 3u8 7u8


//# run 0xCAFE::Caller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
