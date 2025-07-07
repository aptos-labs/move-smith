//# publish
module 0x123::exponentiation_tests {
    // Re-implementing the pow function with a different approach for variety
    public fun pow(base: u64, exponent: u64): u64 {
        let mut result = 1;
        let mut count = 0;
        while (count < exponent) {
            result = result * base;
            count = count + 1;
        };
        result
    }

    // Test different base and exponent combinations, including large values
    public fun test_pow_varied() {
        // Edge case: exponent zero
        assert!(pow(7, 0) == 1, 0);
        // Small values
        assert!(pow(2, 4) == 16, 1);
        // Larger base
        assert!(pow(10, 3) == 1000, 2);
        // Base 1 should always be 1 regardless of exponent
        assert!(pow(1, 100) == 1, 3);
        // Large exponent
        assert!(pow(2, 10) == 1024, 4);
        // Prime base
        assert!(pow(17, 2) == 289, 5);
    }

    // Helper function to compute power using the module's pow function
    public fun run_all_tests() {
        test_pow_varied();
    }
}

//# run 0x123::exponentiation_tests::run_all_tests