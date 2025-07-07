
//# publish
module 0xCAFE::MathOperations {
    public fun add_two_values(a: u8, b: u8): u8 {
        let c = a + b;
        if (c > 100) {
            100
        } else {
            c
        }
    }

    public fun run_lambda_examples(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y + 1
        };
        lambda(7u8, 8u8)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::UseMath {
    use 0xCAFE::MathOperations;

    public fun nested_calls(x: u8, y: u8): u8 {
        let sum = MathOperations::add_two_values(x, y);
        let incremented = MathOperations::inline_increment(sum);
        incremented
    }
}


//# run 0xCAFE::MathOperations::add_two_values --args 40u8 50u8


//# run 0xCAFE::MathOperations::run_lambda_examples


//# run 0xCAFE::UseMath::nested_calls --args 20u8 30u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
