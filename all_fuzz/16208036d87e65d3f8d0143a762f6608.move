
//# publish
module 0xCAFE::AdditionAndLambda {
    // Module to test addition and lambda expressions

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus fixed offset 10 to verify calculation
        sum + 10
    }

    public fun apply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * 2 + y
        };
        lambda(a, b)
    }

    public fun runner() {
        let _ = add_two_values(3u8, 4u8);
        let _ = apply_lambda(5u8, 6u8);
    }
}


//# run 0xCAFE::AdditionAndLambda::add_two_values --args 20u8 22u8


//# run 0xCAFE::AdditionAndLambda::apply_lambda --args 7u8 8u8


//# run 0xCAFE::AdditionAndLambda::runner


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AdditionAndLambda;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let intermediate = AdditionAndLambda::add_two_values(x, y);
        let incremented = inline_increment(intermediate);
        incremented
    }

    public fun runner() {
        let _ = call_nested_functions(10u8, 20u8);
    }
}


//# run 0xCAFE::NestedCalls::call_nested_functions --args 15u8 25u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
