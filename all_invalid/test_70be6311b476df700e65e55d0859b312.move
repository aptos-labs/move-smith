//# publish
module 0x1::nested_loop_test {
    public fun run_nested_breaks() {
        let mut outer_x = 0;
        let mut outer_y = 0;

        // Outer loop
        while (true) {
            let mut inner_counter = 0;

            // Inner loop
            loop {
                inner_counter = inner_counter + 1;

                if (inner_counter == 2) {
                    // Break the inner loop
                    break;
                }
            }

            // After inner loop, update outer_y
            outer_y = outer_y + inner_counter;

            // Decide whether to break outer loop
            if (outer_y >= 4) {
                break;
            }

            outer_x = outer_x + 1;
        }

        // After loops, verify final states
        assert!(outer_x == 1, 42);
        assert!(outer_y == 4, 42);
    }
}

//# run 0x1::nested_loop_test::run_nested_breaks