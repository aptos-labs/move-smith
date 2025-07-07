
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus a fixed offset 10u8
        sum + 10u8
    }

    public fun test_lambda_expression(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y + 1u8
        };
        lambda(a, b)
    }

    public fun runner() {
        let _ = add_two_values(3u8, 4u8);
        let _ = test_lambda_expression(5u8, 6u8);
    }
}


//# run 0xCAFE::Adder::add_two_values --args 20u8 22u8


//# run 0xCAFE::Adder::test_lambda_expression --args 7u8 8u8


//# run 0xCAFE::Adder::runner


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Adder;

    public fun call_inline_and_nested(a: u8, b: u8): u8 {
        let first_sum = Adder::add_two_values(a, b);
        let second_result = Adder::test_lambda_expression(a, b);
        // Return combined result
        first_sum + second_result
    }

    public fun runner() {
        let _ = call_inline_and_nested(2u8, 3u8);
    }
}


//# run 0xCAFE::NestedCaller::call_inline_and_nested --args 10u8 15u8


//# run 0xCAFE::NestedCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
