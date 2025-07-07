
//# publish
module 0xCAFE::TestLambda {
    use std::vector;

    // Helper function that applies a lambda to an argument and returns the result
    public fun apply<A: copy, R>(f: |A| R, arg: A): R {
        f(arg)
    }

    // Helper function that applies a lambda which returns another lambda, then applies that lambda
    public fun apply_nested<A: copy, R: copy>(f: |A| |A| R, arg: A): R {
        let inner_lambda = f(arg);
        inner_lambda(arg)
    }

    // Function to call apply with a simple lambda
    public fun test_apply(): u64 {
        let lambda = |x: u64| { x + 10 };
        let result = apply(lambda, 32u64);
        result
    }

    // Function to call apply_nested with nested lambdas
    public fun test_apply_nested(): u64 {
        let outer = |x: u64| |y: u64| { x + y + 5 };
        let result = apply_nested(outer, 7u64);
        result
    }

    // Function to test applying a lambda that modifies a space, showcasing nested application
    public fun test_nested_apply_with_side_effects(): u64 {
        // Lambda that captures no outer environment, just adds 1
        let incr = |x: u64| { x + 1 };

        // Lambda that applies 'incr' twice
        let double_incr = |x: u64| { apply(incr, apply(incr, x)) };
        let result = apply(double_incr, 10u64);
        result
    }
}


//# run 0xCAFE::TestLambda::test_apply --args


//# run 0xCAFE::TestLambda::test_apply_nested --args


//# run 0xCAFE::TestLambda::test_nested_apply_with_side_effects --args

// Featurres:
// a2d395f7cc514b343f4569a28ad36e2a: Test that the `apply` function correctly executes a passed-in lambda function with provided arguments, and verify that nested `apply` calls produce the expected combined result.
// 0ed158c29b359ddd26da279740e6872a: Define script blocks to implement executable transactions and functions.
// 2393b2a2ba9a0953dccf6edacb3b8b00: Use call chains in specifications to identify and report the sequence of function calls leading to an impure construct.
