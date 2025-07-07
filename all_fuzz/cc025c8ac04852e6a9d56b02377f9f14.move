
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus a constant 10 to test addition and return
        sum + 10
    }

    public fun lambda_demo(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }
}


//# run 0xCAFE::Adder::add_two_values --args 5u8 7u8


//# run 0xCAFE::Adder::lambda_demo --args 8u8 12u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public inline fun inline_add_wrapper(a: u8, b: u8): u8 {
        Adder::add_two_values(a, b)
    }

    public fun call_inline_add_wrapper(x: u8, y: u8): u8 {
        inline_add_wrapper(x, y)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_add_wrapper --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
