
//# publish
module 0xCAFE::Adder {
    // Simple adder module to test addition of two u8 values

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to check final return value is sum plus one
        sum + 1
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a, b| {
            a + b
        };
        adder(x, y)
    }

    // Inline function returns tuple of u8 values as sum and product
    public inline fun inline_ops(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    // Call Adder::inline_ops inline function and return the sum part increased by 10
    public fun call_adder_inline(a: u8, b: u8): u8 {
        let (sum, _product) = Adder::inline_ops(a, b);
        sum + 10
    }

    // Call Adder::call_lambda and add 5 to result
    public fun call_adder_lambda(x: u8, y: u8): u8 {
        let result = Adder::call_lambda(x, y);
        result + 5
    }
}


//# run 0xCAFE::Adder::add_two_values --args 4u8 5u8


//# run 0xCAFE::Adder::call_lambda --args 6u8 7u8


//# run 0xCAFE::NestedCall::call_adder_inline --args 10u8 11u8


//# run 0xCAFE::NestedCall::call_adder_lambda --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
