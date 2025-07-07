//# publish
module 0xabcde::test_module {
    // Test a variable assignment within an if-else structure and ensure the variable updates correctly.
    public fun test_if_assignment_conditionally(p: bool): u64 {
        let mut counter = 10;
        if (p) {
            counter = counter + 5;
        } else {
            counter = counter - 3;
        };
        counter
    }

    // Test that variable updates inside a while loop perform correctly over multiple iterations.
    public fun test_while_loop_accumulate(start: u64, times: u64): u64 {
        let mut total = 0;
        let mut i = 0;
        while (i < times) {
            total = total + start + i;
            i = i + 1;
        };
        total
    }

    // Test that multiple nested if and else blocks correctly update variables and the final expression reflects the latest value.
    public fun test_nested_conditions(p1: bool, p2: bool): u64 {
        let mut result = 0;
        if (p1) {
            result = 100;
            if (p2) {
                result = result + 50;
            } else {
                result = result - 50;
            }
        } else {
            result = 25;
            if (!p2) {
                result = result + 25;
            }
        };
        result
    }

    // Optional: A helper function to run the above tests without arguments.
    public fun run_tests() {
        // These calls are for testing purposes; the return values are not asserted here.
        test_if_assignment_conditionally(true);
        test_if_assignment_conditionally(false);
        test_while_loop_accumulate(3, 4);
        test_nested_conditions(true, true);
        test_nested_conditions(true, false);
        test_nested_conditions(false, false);
    }
}

//# run 0xabcde::test_module::run_tests --args