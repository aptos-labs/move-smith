
//# publish
module 0xCAFE::Calculator {
    public fun add_then_return_Y(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambdas_example(x: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;

        let added = adder(x, 2u8);
        let multiplied = multiplier(added, 3u8);

        multiplied
    }
}


//# run 0xCAFE::Calculator::add_then_return_Y --args 5u8 7u8


//# run 0xCAFE::Calculator::lambdas_example --args 2u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Calculator;

    // Inline function in this module that calls Calculator::add_then_return_Y
    public inline fun inline_add_and_return_Y(a: u8, b: u8): u8 {
        Calculator::add_then_return_Y(a, b)
    }

    public fun caller_of_inline(a: u8, b: u8): u8 {
        inline_add_and_return_Y(a, b)
    }
}


//# run 0xCAFE::NestedCall::caller_of_inline --args 4u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
