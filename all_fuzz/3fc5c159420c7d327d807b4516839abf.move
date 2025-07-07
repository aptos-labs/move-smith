
//# publish
module 0xCAFE::TestAddition {
    // Simple addition of two u8 numbers and returning a fixed u8 result after the addition
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value after computing the sum (to test the function structure)
        42u8
    }

    // A lambda that adds two u8 numbers and returns the sum
    public fun lambda_add(a: u8, b: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    // Inline function returning tuple of increments
    public inline fun inline_increment(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }
}


//# publish
module 0xCAFE::TestLambdaCaller {
    use 0xCAFE::TestAddition;

    // Calls a lambda inside this module and also calls the lambda_add function from TestAddition
    public fun call_lambdas(a: u8, b: u8): (u8, u8) {
        let local_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            if (x > y) {
                x - y
            } else {
                y - x
            }
        };

        let res1 = local_lambda(a, b);
        let res2 = TestAddition::lambda_add(a, b);
        (res1, res2)
    }

    // Calls the inline function from TestAddition module
    public fun call_inline_increment(x: u8): (u8, u8) {
        TestAddition::inline_increment(x)
    }
}


//# run 0xCAFE::TestAddition::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::TestAddition::lambda_add --args 5u8 7u8


//# run 0xCAFE::TestLambdaCaller::call_lambdas --args 8u8 3u8


//# run 0xCAFE::TestLambdaCaller::call_inline_increment --args 100u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
