
//# publish
module 0xCAFE::DifferenceCalculator {
    // Struct with annotated fields
    struct CalculationFields {
        a: u64,
        b: u64,
        sum: u64,
        sum_of_squares: u64,
        square_of_sum: u64,
        difference: u64,
    }

    // Public function that computes the difference for a given n
    public fun calculate_difference(n: u64): u64 {
        // Initialize variables
        let sum = 0;
        let sum_of_squares = 0;
        let i = 1;

        while (i <= n) {
            sum = sum + i;
            sum_of_squares = sum_of_squares + i * i;
            i = i + 1;
        }

        let square_of_sum = sum * sum;

        // Create a struct instance with all calculated fields
        let calculation = CalculationFields {
            a: n,
            b: n,
            sum: sum,
            sum_of_squares: sum_of_squares,
            square_of_sum: square_of_sum,
            difference: square_of_sum - sum_of_squares,
        };

        calculation.difference
    }

    // Exit state analysis function
    public fun analyze_exit_states(n: u64): (u64, u64) {
        let diff = calculate_difference(n);
        (diff, n)
    }

    // Runner to test for 10 and 100
    public fun run_calculations() {
        let diff10 = calculate_difference(10);
        let diff100 = calculate_difference(100);
        // No specific assertions, just expose results
        // In real tests, you could print or log
        move—to resource or global storage if needed
        // For this test, just computations
    }
}


//# run 0xCAFE::DifferenceCalculator::run_calculations


//# publish
module 0xCAFE::DiffAnalysis {
    use 0xCAFE::DifferenceCalculator;

    // Function to call analysis for given n
    public fun run_analysis_for_10() {
        let (diff, n) = DifferenceCalculator::analyze_exit_states(10);
        // Could log or expose
    }

    public fun run_analysis_for_100() {
        let (diff, n) = DifferenceCalculator::analyze_exit_states(100);
        // Could log or expose
    }
}


//# run 0xCAFE::DiffAnalysis::run_analysis_for_10 --signers 0xCAFE

//# run 0xCAFE::DiffAnalysis::run_analysis_for_100 --signers 0xCAFE

// Featurres:
// aaed2d449943518d0cfabe6136d81025: Test that the function correctly calculates the difference between the square of the sum and the sum of squares for a given n, specifically verifying it for n=10 and n=100.
// fba38b4ca80ef898ced04dc8e2b5c071: Use ExitStateAnalysis to analyze function exit states.
// 1c32d05a965359cfb36c42c86cc9213c: Annotate fields with types in struct or resource declarations by specifying 'field_name: type' syntax.
