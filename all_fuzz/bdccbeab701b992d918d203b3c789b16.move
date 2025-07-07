
//# publish
module 0xCAFE::Calculator {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        let final_val = if (sum > 10) {
            42u8
        } else {
            10u8
        };
        final_val
    }

    public fun create_lambda_return_result(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let l = adder;
        let res = l(3u8, 4u8);
        res
    }
}


//# run 0xCAFE::Calculator::add_u8 --args 3u8 4u8


//# run 0xCAFE::Calculator::create_lambda_return_result



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calculator;

    public fun call_inline_and_nested(a: u8, b: u8): u8 {
        let sum = Calculator::add_u8(a, b);
        // Use inline lambda in this function
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let product = multiply(a, b);
        if (sum > product) {
            sum + product
        } else {
            product + sum
        }
    }
}


//# run 0xCAFE::Caller::call_inline_and_nested --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
