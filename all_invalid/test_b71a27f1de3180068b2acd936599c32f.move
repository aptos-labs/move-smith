//# publish
module 0x42::Test {

    //# run 0x42::Test::test_capture_shadowing
    public fun test_capture_shadowing() {
        let outer_var = 2;
        fun inner_fn(f_outer:|u64|, captured_outer: &mut u64) {
            // Shadowed variable inside the function
            let outer_var = 5;
            // Modify the outer variable via captured reference
            *captured_outer = outer_var;
            // Call the function with the outer variable
            f_outer(outer_var);
        }

        let mut outer_var_holder = outer_var;
        // Call inner_fn, passing a closure and a reference to outer_var_holder
        inner_fn(|val: u64| {
            // Here, val should be 5 after execution
            // Do nothing special, just for test
        }, &mut outer_var_holder);
        // After function call, check if outer_var_holder has been modified to 5
        assert!(outer_var_holder == 5, 0);
    }

    //# run 0x42::Test::test_loop_continue_break
    public fun test_loop_continue_break() {
        let x = 0;
        let mut y = 0;
        let mut x_counter = 0;

        loop {
            if (x_counter >= 15) {
                break;
            }
            x_counter = x_counter + 1;
            if (x_counter % 2 == 0) {
                continue; // Skip even numbers
            }
            y = y + x_counter;
        }
        // x_counter counts to 15, only odd numbers are added to y
        // Sum of odd numbers from 1 to 15: 1 + 3 + 5 + 7 + 9 + 11 + 13 + 15 = 64
        assert!(y == 64, 0);
    }
}