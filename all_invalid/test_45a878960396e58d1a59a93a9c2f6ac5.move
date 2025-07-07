//# publish
module 0xA11CE::NestedLambdaTest {
    // Define a module with an `apply` function that takes a lambda and two u64s, returning the lambda invoked.
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }
    
    // Function to test nested lambdas for complex arithmetic
    public fun compute(): u64 {
        // First, compute multiplication using a nested lambda
        let mult_result = Self::apply(|a, b| a * b, 5, 4); // 20
        // Then, add a constant to the result by applying an addition lambda
        let add_result = Self::apply(|a, b| a + b, mult_result, 10); // 30
        // Use nested lambdas to compose more complex operation: (5 + 4) * (10 + 2)
        let nested = Self::apply(
            |p1, p2| p1 * p2,
            // Inner lambda to sum two values
            |a, b| Self::apply(|x, y| x + y, a, 2), // sum with 2
            // Inner lambda to sum two values
            |a, b| Self::apply(|x, y| x + y, b, 0),
        );

        // To make it more interesting, let's use nested lambdas to double and then add
        let step1 = Self::apply(|a, b| a * b, 3, 7); // 21
        let step2 = Self::apply(|a, b| a + b, step1, step1); // 42
        nested + add_result + step2 // 30 + 42 = 72
    }
}

//# run 0xA11CE::NestedLambdaTest::compute