
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    // simple struct for key usage
    struct Data has key, store {
        val: u8,
    }

    // function that adds two u8 values and returns sum + 10
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // function that creates and uses lambda expression: returns lambda(x) + y
    public fun lambda_add_sub(y: u8): u8 {
        let add_ten: |u8|u8 has copy+drop = |a: u8| {
            a + 10
        };
        let res = add_ten(y);
        res
    }

    // function that returns a lambda that captures an argument and returns sum
    public fun make_adder(x: u8): |u8|u8 {
        let lambda: |u8|u8 has copy+drop = move |y: u8| {
            x + y
        };
        lambda
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    // call add_and_offset from LambdaTest and returns its result plus another offset
    public fun call_add_offset(x: u8, y: u8): u8 {
        let a = LambdaTest::add_and_offset(x, y);
        a + 5
    }

    // call the lambda_add_sub from LambdaTest with argument y and return result + 2
    public fun call_lambda_add_sub(y: u8): u8 {
        let res = LambdaTest::lambda_add_sub(y);
        res + 2
    }

    // call the make_adder function and then call the resulting lambda with argument 5
    public fun call_make_adder(x: u8): u8 {
        let adder = LambdaTest::make_adder(x);
        adder(5u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 3u8 7u8


//# run 0xCAFE::LambdaTest::lambda_add_sub --args 15u8


//# run 0xCAFE::LambdaTest::make_adder --args 10u8


//# run 0xCAFE::InlineCaller::call_add_offset --args 2u8 3u8


//# run 0xCAFE::InlineCaller::call_lambda_add_sub --args 8u8


//# run 0xCAFE::InlineCaller::call_make_adder --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
