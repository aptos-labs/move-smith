//# publish
module 0x1::RangeTest {
    use std::vector;

    /// Function to test iteration over a range from 0 to 10
    //# run
    script {
        fun main(): () {
            let mut sum: u64 = 0;
            for (i in 0..10) {
                sum = sum + i;
            };
            // The sum should now be 45 (0+1+2+3+4+5+6+7+8+9)
        }
    }

    /// Function to test nested loops with break and ensure proper control flow
    //# run
    script {
        fun main() {
            let mut outer_counter = 0;
            let mut inner_counter = 0;

            loop {
                outer_counter = outer_counter + 1;

                loop {
                    inner_counter = inner_counter + 1;
                    if (inner_counter >= 3) {
                        break;
                    }
                };

                // Break outer loop when outer_counter reaches 2
                if (outer_counter >= 2) {
                    break;
                }
            };

            // After loops, outer_counter should be 2, inner_counter should be 3
        }
    }

    /// Additional test: Combine range iteration with nested loops and break conditions
    //# run
    script {
        fun main() {
            let mut total_sum: u64 = 0;

            for (i in 0..5) {
                let mut inner_sum: u64 = 0;
                let mut j = i;
                loop {
                    inner_sum = inner_sum + j;
                    j = j + 1;
                    if (j >= i + 3) {
                        break;
                    }
                };
                total_sum = total_sum + inner_sum;
            };

            // total_sum should accumulate the sums over each iteration
        }
    }

    /// Runner function to execute all tests sequentially
    //# run 0x1::RangeTest::run_tests
    script {
        fun run_tests() {
            // Call the range iteration test
            // No explicit output, but in real test, assertions would verify the sums
            main();

            // Call the nested loop test
            main();

            // Call the combined nested loops test
            main();
        }
    }
}