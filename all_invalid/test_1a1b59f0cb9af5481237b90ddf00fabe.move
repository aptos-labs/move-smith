//# publish
module 0x42::Test {

    public inline fun perform_with_capture(f: |&mut u64|) {
        let mut outer_value = 0;
        f(&mut outer_value);
        // The function can modify outer_value via the captured reference
    }

    public fun test_capture_and_modification() {
        let mut x = 2;
        perform_with_capture(|ref mut y: &mut u64| {
            *y = 4; // Modify the outer variable through the captured reference
        });
        // We expect x to be updated to 4 after perform_with_capture
        assert!(x == 4, 0);
    }

    public inline fun execute_callback(f:|u64|): u64 {
        let initial_value = 5;
        f(initial_value);
        initial_value
    }

    public fun test_inner_function_accesses_outer_var() {
        let mut x = 0;
        execute_callback(|val: u64| {
            x = val * 2; // Should set x to 10
        });
        // After calling execute_callback, x should be updated
        assert!(x == 10, 0);
    }

    public fun run_shadowing_in_nested() {
        let outer = 10;
        // Shadowing outer variable in inner scope
        let outer = outer + 1;
        // Should be 11
        assert!(outer == 11, 0);
    }
}

//# run 0x42::Test::test_capture_and_modification
//# run 0x42::Test::test_inner_function_accesses_outer_var
//# run 0x42::Test::run_shadowing_in_nested