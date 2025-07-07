
//# publish
module 0xCAFE::Adder {
    public fun add_two_u8_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            10
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        adder(x, y)
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public inline fun inline_add(x: u8, y: u8): u8 {
        Adder::add_two_u8_values(x, y)
    }

    public fun call_inline() : u8 {
        inline_add(3u8, 4u8)
    }
}


//# run 0xCAFE::Adder::add_two_u8_values --args 4u8 6u8


//# run 0xCAFE::Adder::lambda_example --args 5u8 7u8


//# run 0xCAFE::NestedCall::call_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
