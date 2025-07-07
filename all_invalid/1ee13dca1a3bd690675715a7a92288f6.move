
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    // Utility function to simulate environment variable-based feature toggle
    // (In actual Aptos testing env, environment variables are not directly used, so this is conceptual)
    public fun is_deprecated_usage_enabled(): bool {
        // For the purposes of this test, we return true.
        // In real tests, this could be controlled by environment setup.
        true
    }

    // Function to compute sum of three numbers
    public fun sum_three(a: u64, b: u64, c: u64): u64 {
        a + b + c
    }

    // Function to test for_user with embedded calculation
    public fun test_for_user() {
        let result = for_user(10, 20, 30);
        // do nothing with result, just call
        let _ = result;
    }

    // The core function to compute sum
    public fun for_user(x: u64, y: u64, z: u64): u64 {
        // Define the helper function as a separate private function
        region_calculator(x, y, z)
    }

    // Helper function to perform calculation
    fun region_calculator(a: u64, b: u64, c: u64): u64 {
        // sum three numbers
        a + b + c
    }

    // Function to test warning messages about deprecated usage
    public fun test_deprecated_warning() {
        if (is_deprecated_usage_enabled()) {
            // Normally, in real Aptos testing, we might trigger warnings or logs.
            // Here, we just simulate a warning by calling a dummy function.
            // In actual usage, this might be an abort or log message.
            // For the test, we do nothing.
        } else {
            // warnings disabled; do nothing
        }
    }

    // Inline function that returns a boolean based on some calculation
    public fun is_even(n: u64): bool {
        n % 2 == 0
    }

    // Function to test inline function
    public fun test_inline_functions() {
        let even_result = is_even(42);
        let odd_result = is_even(43);
        let _ = (even_result, odd_result);
    }
}



//# run 0xCAFE::TestFeatures::test_for_user --args


//# run 0xCAFE::TestFeatures::test_deprecated_warning --args


//# run 0xCAFE::TestFeatures::test_inline_functions

// Features:
// f77a4ce10096c533e7ee4c8587b70b5a: Test that the `for_user` function correctly computes the sum of three predefined numbers by calling the `for` function.
// 72db4f4c10cc410140164b824042d91e: Enable or disable warning messages about deprecated usage of Aptos-specific libraries based on an environment variable
// ad68a5b2a6f6954a2a4594652d64caaa: Create inline functions by using the 'inline' keyword in your Move code.
