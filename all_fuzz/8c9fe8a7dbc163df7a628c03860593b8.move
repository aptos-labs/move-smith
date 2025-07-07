
//# publish
module 0xCAFE::AddAndLambda {
    // Module tests addition and lambda functions

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Always end `if` statements with a semicolon
        if (sum > 10) {
            let _ = 10;
        } else {
            let _ = 20;
        };
        sum
    }

    public fun lambda_test(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(7u8, 8u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_values --args 5u8 6u8


//# run 0xCAFE::AddAndLambda::lambda_test



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let first_sum = AddAndLambda::add_two_values(x, y);
        let incremented = inline_increment(first_sum);
        let final_sum = AddAndLambda::add_two_values(incremented, 1u8);
        final_sum
    }
}


//# run 0xCAFE::NestedInlineCall::call_nested_functions --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
