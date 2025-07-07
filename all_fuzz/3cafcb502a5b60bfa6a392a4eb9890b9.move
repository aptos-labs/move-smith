
//# publish
module 0xCAFE::LambdaTest {
    // Lambda that adds two u8 numbers and returns the sum
    public fun add_two_numbers_with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    // Function uses a lambda to add, then returns the sum plus a constant 5
    public fun add_and_add_five(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = add_lambda(a, b);
        sum + 5u8
    }

    // Function uses nested lambda to add and multiply, returning their sum
    public fun sum_add_and_mul(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let mul_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x * y };
        add_lambda(a, b) + mul_lambda(a, b)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    // Call LambdaTest::add_two_numbers_with_lambda inline function pattern
    public fun call_add(a: u8, b: u8): u8 {
        LambdaTest::add_two_numbers_with_lambda(a, b)
    }

    // Call LambdaTest::add_and_add_five function
    public fun call_add_and_add_five(a: u8, b: u8): u8 {
        LambdaTest::add_and_add_five(a, b)
    }

    // Call LambdaTest::sum_add_and_mul function
    public fun call_sum_add_and_mul(a: u8, b: u8): u8 {
        LambdaTest::sum_add_and_mul(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_two_numbers_with_lambda --args 10u8 15u8


//# run 0xCAFE::LambdaTest::add_and_add_five --args 7u8 8u8


//# run 0xCAFE::LambdaTest::sum_add_and_mul --args 6u8 3u8


//# run 0xCAFE::InlineCaller::call_add --args 20u8 22u8


//# run 0xCAFE::InlineCaller::call_add_and_add_five --args 2u8 3u8


//# run 0xCAFE::InlineCaller::call_sum_add_and_mul --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
