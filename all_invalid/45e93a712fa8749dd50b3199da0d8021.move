//# publish
module 0xCAFE::ExpressionLinterTest {
    // Test module for expression linters configurations and return expression usage

    public fun sum_multiples(limit: u64): u64 {
        let mut sum = 0u64;

        let mut i = 0u64;
        while (i < limit) {
            if ((i % 3) == 0 || (i % 5) == 0) {
                sum = sum + i;
            };
            i = i + 1;
        };

        return sum;
    }

    public fun run_no_args(): u64 {
        // Should return sum of multiples of 3 or 5 below 10 = 3 + 5 + 6 + 9 = 23
        return sum_multiples(10);
    }
}

//# run 0xCAFE::ExpressionLinterTest::sum_multiples --args 100u64

//# run 0xCAFE::ExpressionLinterTest::run_no_args

// Featurres:
// ec97d2e34e377a9fff9157a5c5e07d6b: Configure the set of expression linters to apply during code analysis.
// f764811ed35e98cd9106dc1292628e34: Return values from functions or blocks with the `return` expression.
// 7ec96e2fbe9c752e7f502761ab591b1d: Test that the function correctly calculates the sum of all numbers below a given limit that are multiples of 3 or 5.
