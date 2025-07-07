
//# publish
module 0xCAFE::Adder {
    // A module to test addition of two u8 values and return
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to have a specific result that is sum + 10
        sum + 10
    }

    public fun lambda_test(x: u8): u8 {
        let closure: |u8|u8 = |y: u8| {
            y + 2u8
        };
        // Apply closure to x and then add 5
        let result = closure(x) + 5u8;
        result
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Adder;

    // Call Adder::add_then_return_sum and use its result to call a lambda inside here
    public fun call_add_and_lambda(a: u8, b: u8): u8 {
        let sum_plus_10 = Adder::add_then_return_sum(a, b);

        // Lambda that doubles input
        let double_lambda: |u8|u8 = |v: u8| {
            2 * v
        };

        double_lambda(sum_plus_10)
    }

    // Call Adder::lambda_test from here and add 1
    public fun call_lambda_test_plus_one(x: u8): u8 {
        let val = Adder::lambda_test(x);
        val + 1u8
    }
}


//# run 0xCAFE::Adder::add_then_return_sum --args 3u8 4u8


//# run 0xCAFE::Adder::lambda_test --args 10u8


//# run 0xCAFE::InlineCaller::call_add_and_lambda --args 3u8 4u8


//# run 0xCAFE::InlineCaller::call_lambda_test_plus_one --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
