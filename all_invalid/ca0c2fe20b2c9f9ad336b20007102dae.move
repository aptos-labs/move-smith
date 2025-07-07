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
        let i = 0;
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
    // Test that modifying a borrowed mutable reference does not affect the original value in an assertion
    fun main() {
        let original_value = 42u64;
        let borrowed_value = &mut original_value;
        // Mutably borrow and modify the value
        0xCAFE::TestModule::modify_borrowed(borrowed_value);
        // The original_value should be increased by 10
        assert(original_value == 52u64);
        // For the purpose of the test, we can check that the function returns the correct sum
        let sum_result = 0xCAFE::TestModule::sum_of_multiples(10);
        // Numbers below 10 that are multiples of 3 or 5 are 0,3,5,6,9 -> sum = 0+3+5+6+9=23
        assert(sum_result == 23u64);
    }
}

// Featurres:
// f398bceb356c681d2fb7b53580c66fcb: Define spec-only modules for Move smart contract verification
// ff16a95e0f30a19975f0caf60cfe06bd: Test that mutably borrowing a parameter and modifying it within a function does not affect the function’s return value when the original value is used in an assertion.
// 7ec96e2fbe9c752e7f502761ab591b1d: Test that the function correctly calculates the sum of all numbers below a given limit that are multiples of 3 or 5.
