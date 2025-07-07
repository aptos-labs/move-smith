//# publish
module 0x1::test_module {

    // Function to be called for testing parameter and variable usage.
    public fun test_params_and_vars(p1: u64, p2: u64) {
        let local1 = p1 + p2;            // Addition
        let local2 = p1 - p2;             // Subtraction
        let local3 = p1 * p2;             // Multiplication
        // To prevent division by zero, ensure p2 != 0 before division
        if (p2 != 0) {
            let div_result = p1 / p2;     // Division
            let modulo_result = p1 % p2;  // Modulo
        } else {
            // Handle division/modulo by zero (no operation or error)
        }
    }

    // Define a non-native inline function with body to test inline function compilation.
    fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Function to test arithmetic operations with boundary conditions.
    public fun test_arithmetic() {
        // Normal values
        let sum = 123u64 + 456u64;
        let diff = 500u64 - 200u64;
        let prod = 20u64 * 30u64;
        let div = 100u64 / 25u64;
        let modulo = 100u64 % 30u64;
        
        // Boundary values
        let max = 0xffff_ffff_ffff_ffffu64; // max u64
        let min = 0u64;

        // Testing addition overflow (should fail at compile time or runtime if checked)
        // move doesn't automatically check overflow, but in a real test, try to cause overflow
        // For the purpose of compilation, we just do an example (won't compile if unchecked)
        // let overflow_sum = max + 1u64; // This would overflow if checked

        // Testing subtraction underflow (simulate with checked subtraction)
        // move allows wrapping unless explicitly checked
        // So, here, we intentionally do operations that could overflow if unchecked.
        // For test purposes, assume wrapping
        let underflow_sub = min - 1u64; // wraps around to max
        // Testing multiplication overflow
        // For large values, this can overflow
        let overflow_prod = max * 2u64; // wraps around
        // Division by zero: should cause a failure if attempted, but we simulate the call
        // move's division by zero results in abort at runtime. For test, we can call in a safe block.

        // To mimic division by zero check
        // Uncommenting below would cause runtime abort
        // let _ = 10u64 / 0u64; // Should abort
    }

    // Runner function to execute tests
    public fun run_tests() {
        // Call parameter and variable usage test
        Self::test_params_and_vars(100u64, 25u64);
        // Call arithmetic test
        Self::test_arithmetic();
    }
}

//# run 0x1::test_module::run_tests --signers 0x1