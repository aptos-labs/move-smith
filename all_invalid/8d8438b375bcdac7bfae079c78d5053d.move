//# publish
module 0x1::TestLoopBehavior {
    use std::assert;

    // Test that the body of a while loop is not executed when the condition is false.
    public fun test_loop_not_executed() {
        let executed = false;
        let condition = false;

        // Loop label for identification
        'loop_label: while (condition) {
            // This block should not execute
            executed = true;
        }

        // Assert that the loop body was not executed
        assert::is_false(&executed, 0);
    }

    // Test variable shadowing inside and outside the while loop
    public fun test_variable_shadowing() {
        let x = 10;

        // Shadowing 'x' inside the loop
        'outer_loop: while (x > 0) {
            let x = x + 1; // shadowed variable
            // Increment shadowed 'x'
            x = x + 1;

            // Update outer x
            x = x - 2;

            // Ensure inner 'x' does not affect outer 'x'
            assert::is_true(&(x > 0), 1);
        }

        // After loop, check that outer 'x' is unchanged
        assert::equals(&x, &10, 2);
    }

    // Test local variable assignments inside and outside a while loop
    public fun test_variable_assignments() {
        let count = 0;

        // Loop label
        'count_loop: while (count < 5) {
            let temp = count; // local variable inside loop
            temp = temp + 1;
            count = count + 1; // update outer variable
        }

        // After loop, count should be 5
        assert::equals(&count, &5, 3);
    }
}
