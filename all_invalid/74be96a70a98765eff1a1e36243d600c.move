//# publish
module 0x1::TestAnalysisAndOperations {
    // 1. Function to analyze usage of parameters and variables
    public fun analyze_usage(param1: u64, param2: address) {
        let local_var1 = param1 + 10; // using parameter and local variable
        let local_var2 = local_var1 * 2;
        let local_var3 = local_var2 - 5;
        // use param2 to create a vector (simulate usage)
        let vec = vector::empty<u8>();
        vector::push_back(&mut vec, 1);
        vector::push_back(&mut vec, 2);
        vector::push_back(&mut vec, 3);
        // dummy usage to prevent warnings
        if (local_var3 > 100) {
            // do nothing
        };
    }

    // 2. Define an inline non-native function with a body
    inline fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // 3. Functions for arithmetic operations testing
    public fun test_arithmetic() {
        // Normal cases
        let sum = 100u64 + 200u64;
        let diff = 300u64 - 100u64;
        let prod = 20u64 * 3u64;
        let quotient = 100u64 / 4u64;
        let modulo = 20u64 % 3u64;

        // Boundary conditions
        let max_u64 = 18446744073709551615u64;
        let min_u64 = 0u64;

        // Addition overflow (should fail at compile or runtime)
        // Commented out to avoid abort during test
        // let overflow_add = max_u64 + 1; // Should fail or overflow

        // Subtraction underflow (should fail)
        // let underflow_sub = min_u64 - 1; // Should fail or underflow

        // Multiplication overflow (should fail or overflow)
        // let overflow_mul = max_u64 * 2; // Should fail or overflow

        // Division by zero (should cause abort)
        // let div_zero = 100u64 / 0;
        // Modulo by zero (should cause abort)
        // let mod_zero = 100u64 % 0;

        // Use inline function
        let inline_result = inline_add(50, 70);
    }

    // Runner function to execute test_arithmetic
    public fun run_tests() {
        test_arithmetic();
    }
}

//# run 0x1::TestAnalysisAndOperations::analyze_usage --signers 0x0 --args 42u64 0xABCDEF
//# run 0x1::TestAnalysisAndOperations::run_tests --signers 0x0