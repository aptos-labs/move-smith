
//# publish
module 0xCAFE::Adder {
    // A simple module to add two u8 values

    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value for testing purpose
        42u8
    }

    public fun lambda_examples(): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let multiplier: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let added = adder(3u8, 4u8);
        let multiplied = multiplier(3u8, 4u8);
        added + multiplied
    }
}


//# run 0xCAFE::Adder::add_then_return_fixed --args 10u8 15u8


//# run 0xCAFE::Adder::lambda_examples



//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::Adder;

    public inline fun inline_add(a: u8, b: u8): u8 {
        Adder::add_then_return_fixed(a, b)
    }

    public fun call_nested_inline(): u8 {
        inline_add(5u8, 10u8)
    }
}


//# run 0xCAFE::NestedInlineCaller::call_nested_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
