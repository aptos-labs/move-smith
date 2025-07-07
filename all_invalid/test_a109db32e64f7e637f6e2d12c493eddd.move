//# publish
module 0xA1::nested_loops_tests {

    //# run
    script {
        fun main(): () {
            let total = 0;
            let outer_counter = 0;

            // Outer for loop: from 0 to 4
            for (i in 0..5) {
                // Increment total for each outer iteration
                total = total + 2;
                outer_counter = outer_counter + 1;

                // Inner while loop: runs while tot < 12
                while (total < 12) {
                    total = total + 3;
                };
            };

            // After loops, total should be 17 (because 2*5=10, then inner loops add 3 for each outer iteration)
            // Outer counter should be 5
            assert!(total == 17, 100);
            assert!(outer_counter == 5, 101);

            // Now, implement a nested control flow with variable scope
            let sum = 0;
            let mut i_counter = 0;

            // Outer while loop
            while (i_counter < 3) {
                let mut inner_sum = 0;

                // Inner for loop
                for (j in 0..4) {
                    inner_sum = inner_sum + j;
                };

                sum = sum + inner_sum;
                i_counter = i_counter + 1;
            };

            // inner_sum for each outer iteration: 0+1+2+3=6
            // sum after 3 iterations: 6*3=18
            assert!(sum == 18, 102);
        }
    }

    //# run 0xA1::nested_loops_tests::main
}