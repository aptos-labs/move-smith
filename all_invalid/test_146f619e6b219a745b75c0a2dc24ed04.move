//# publish
module 0xAABB::LambdaTester {
    // Inline function accepting a lambda that takes two u64 parameters and returns u64.
    // The main function will pass two lambdas that each return their input multiplied by 2 and 3 respectively.
    // The goal is to verify that the lambdas are invoked correctly and results are summed.
    inline fun apply_and_sum(f: |u64, u64| u64, g: |u64, u64| u64, x: u64, y: u64): u64 {
        f(x, y) + g(x, y)
    }

    public fun main(): u64 {
        let lambda1 = |a: u64, b: u64| a * 2;
        let lambda2 = |a: u64, b: u64| b * 3;
        apply_and_sum(lambda1, lambda2, 5, 10)
    }
}

//# run 0xAABB::LambdaTester::main

//# publish
module 0xC0DE::LambdaInvoker {
    // Define a public function that takes two lambdas and an input, calls each lambda with the input,
    // and returns their results.
    inline fun invoke_both(f: |u64| u64, g: |u64| u64, val: u64): (u64, u64) {
        (f(val), g(val))
    }

    public fun main(): u64 {
        // Define lambdas that double and triple the input.
        let dbl = |n: u64| n * 2;
        let trp = |n: u64| n * 3;
        // Call invoke_both with input 7
        let (res1, res2) = invoke_both(dbl, trp, 7);
        // Sum the results for verification
        res1 + res2
    }
}

//# run 0xC0DE::LambdaInvoker::main

//# publish
module 0xDADA::NestedLambda {
    // Main function to test nested lambdas and multi-level invocation.
    public fun main(): u64 {
        // Outer lambda returns an inner lambda that adds two numbers.
        // When invoked, it should return the sum.
        let outer = |a: u64| {
            // Inner lambda adds its two parameters
            |b: u64, c: u64| b + c + a
        };
        // Get inner lambda with a as 4
        let inner_lambda = outer(4);
        // Call inner lambda with 3 and 5
        inner_lambda(3, 5)
    }
}

//# run 0xDADA::NestedLambda::main

//# publish
module 0xFEED::ComplexLambda {
    // This test verifies that lambdas capturing environment variables work correctly
    public fun main(): u64 {
        let offset1 = 10;
        let offset2 = 20;

        // Lambda that captures offset1
        let lambda1 = |x: u64| x + offset1;
        // Lambda that captures offset2
        let lambda2 = |x: u64| x + offset2;

        // Inline function to apply a lambda twice and sum results.
        fun apply_twice(f: |u64| u64, val: u64): u64 {
            f(val) + f(val + 1)
        }

        // Calculate sum of applications
        let sum1 = apply_twice(lambda1, 5);
        let sum2 = apply_twice(lambda2, 5);
        sum1 + sum2
    }
}

//# run 0xFEED::ComplexLambda::main