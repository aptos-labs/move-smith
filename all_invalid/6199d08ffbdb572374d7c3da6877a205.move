
//# publish
module 0xCAFE::ConstantsAndFunctions {
    // Define constants with distinct values
    const CONST_A: u64 = 42;
    const CONST_B: u64 = 100;
    const CONST_C: u64 = 7;

    // Function that sums numbers from 1 to 10
    public fun sum_from_1_to_10(): u64 {
        let sum = 0u64;
        let i = 1u64;
        while (i <= 10) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    // Function to combine constants and computed sum
    public fun compute_total(): u64 {
        let sum = sum_from_1_to_10();
        let total = sum + CONST_A + CONST_B + CONST_C;
        total
    }

    // Test function to verify total calculation
    // test]
    public fun test_constants_and_computation(): bool {
        let expected_total = 65 + 42 + 100 + 7; // sum from 1..10 is 55; total should be 55 + 42 + 100 + 7 = 204
        let actual_total = compute_total();
        // Assert that actual_total equals expected_total
        assert!(actual_total == expected_total, 999);
        // Return true if assertion passes
        true
    }
}


//# run 0xCAFE::ConstantsAndFunctions::test_constants_and_computation


// Featurres:
// 646d4127a24c340b4a97e5cc7f22b5a9: Define constants with specific names and values in Move modules.
// ff8b56e9c55ebf08e7edfef4e331cd40: Write Move module test functions that can be automatically collected and executed by the compiler's test framework.
// 36da377b0d0e8bddb5c9128999d55cbb: Test that the function accurately computes the sum of numbers from 10 down to 1 and combines it with initial values to produce the correct total of 65.
