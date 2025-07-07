
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 to check addition and return specific value
        sum + 10
    }

    public fun lambda_add_subtract(a: u8, b: u8): (u8, u8) {
        let add: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let subtract: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            // Since Move unsigned, ensure no underflow by `(x >= y) ? x - y : 0`
            if (x >= y) {
                x - y
            } else {
                0
            }
        };
        (add(a, b), subtract(a, b))
    }

    public fun lambda_call_lambda() {
        let combine: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            let (sum, diff) = Self::lambda_add_subtract(x, y);
            (sum + 1, diff + 1)
        };
        let (_s, _d) = combine(10, 5);
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        // Call add_two_values from LambdaTest module
        LambdaTest::add_two_values(a, b) + 5
    }

    public fun call_inline(): u8 {
        inline_add(2, 3)
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 7u8 8u8


//# run 0xCAFE::LambdaTest::lambda_add_subtract --args 10u8 3u8


//# run 0xCAFE::LambdaTest::lambda_call_lambda


//# run 0xCAFE::InlineCaller::call_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
