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
        // To address the 'copy' requirement, we need to ensure 'incr' is copyable
        let double_incr = |x: u64| {
            let temp = apply(incr, x); // apply first incr
            apply(incr, temp)          // apply second incr
        };
        let result = apply(double_incr, 10u64);
        result
    }
}