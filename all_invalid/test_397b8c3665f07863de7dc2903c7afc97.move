//# publish
module 0xA1B2::NestedFunctionCalls {
    // Reuse the `apply` inline function, but test with different nested operations and parameters
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    // Function that tests deeply nested `apply` calls with mixed operations
    public fun test_nested_applications(): u64 {
        // Compose nested function calls
        let result1 = apply(|x, y| x + y, 10, apply(|x, y| x * y, 3, 2));
        // Expected: 10 + (3 * 2) = 10 + 6 = 16

        let result2 = apply(|x, y| x - y, result1, apply(|x, y| x + y, 5, 4));
        // Expected: 16 - (5 + 4) = 16 - 9 = 7

        let result3 = apply(|x, y| x * y, result2, 2);
        // Expected: 7 * 2 = 14

        result3
    }
    
    // Runner function to execute the nested test
    public fun run_test() {
        let final_result = test_nested_applications();
        // No assertion needed for the test, but could be checked externally
        // For demonstration, returning the final result
        final_result
    }
}

//# run 0xA1B2::NestedFunctionCalls::run_test

//# publish
module 0xA1B2::InlineFunctionInteraction {
    // Define an inline function `foo` that accepts a function pointer and arguments
    inline fun foo(g: |u64, u64, u64, u64| u64, x: u64, y: u64, z: u64, q: u64): u64 {
        g(x, y, z, q)
    }

    // Function to test `foo` with a specific lambda that combines arguments
    public fun test() {
        let result = foo(|a, b, c, d| a + b + c + d, 1, 2, 3, 4);
        // Expect 1+2+3+4=10
        // For this test, we could print or return result; here, we just rely on the correctness
        assert!(result == 10, 0);
    }
}

//# run 0xA1B2::InlineFunctionInteraction::test