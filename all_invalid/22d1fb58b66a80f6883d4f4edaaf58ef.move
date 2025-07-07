//# publish
module 0xCAFE::__spec_only {
    // This is a placeholder module for spec or verification purposes, no functions are needed here for this test
}

//# publish
module 0xCAFE::TestModule {
    use 0xCAFE::__spec_only;

    // Function that mutably borrows a u64 parameter and modifies it
    public fun modify_borrowed(x: &mut u64) {
        *x = *x + 10;
    }

    // Function to calculate the sum of all numbers below limit that are divisible by 3 or 5
    public fun sum_of_multiples(limit: u64): u64 {
        let sum = 0;
        let mut i = 0;
        while (i < limit) {
            if (i % 3 == 0 || i % 5 == 0) {
                sum = sum + i;
            }
            i = i + 1;
        }
        sum
    }
}

//# run
script {
    fun main() {
        let mut original_value = 42u64;
        let borrowed_value = &mut original_value;
        // Mutably borrow and modify the value
        0xCAFE::TestModule::modify_borrowed(borrowed_value);
        // The original_value should be increased by 10
        // Note: In move, to use 'assert' in tests, usually the test framework or external tools are used.
        // But since the original test expects assertions, assume environment supports 'assert' in scripts.
        assert(original_value == 52u64);
        // Check sum of multiples below 10
        let sum_result = 0xCAFE::TestModule::sum_of_multiples(10);
        // Numbers below 10 that are multiples of 3 or 5: 0,3,5,6,9 -> sum=23
        assert(sum_result == 23u64);
    }
}