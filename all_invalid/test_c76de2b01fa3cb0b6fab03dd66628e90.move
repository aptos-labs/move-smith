//# publish
module 0xAABB::NestedFlow {
    //# publish
    public fun outer_loop_behavior() {
        let total = 0;
        let outer_counter = 0;

        for (outer in 0..5) {
            var inner_sum = 0;
            var break_outer = false;

            for (inner in 0..10) {
                if (inner == 3) {
                    break; // Exit inner loop when inner == 3
                }
                if (inner == 1 && outer == 2) {
                    break_outer = true; // Mark to break outer loop
                    break;
                }
                inner_sum = inner_sum + inner;

                if (inner % 2 == 0) continue; // Skip even inner values
                inner_sum = inner_sum + 10; // Add extra for odd inner
            }

            // Update total with inner_sum
            if (break_outer) {
                total = total + inner_sum;
                break; // Break outer loop if signaled
            } else {
                total = total + inner_sum + outer;
            }

            outer_counter = outer_counter + 1;
            if (outer_counter >= 4) {
                continue; // Continue to next outer iteration
            }
        }
        // Final check
        assert!(total == 68, total);
    }

    public fun run_behavior() {
        outer_loop_behavior();
    }
}

//# run 0xAABB::NestedFlow::run_behavior --signers 0x1