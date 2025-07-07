//# publish
module 0xabc::test_assignments_loops {
    // Function that tests multiple variable assignments and updates in a loop
    public fun test_assignment_and_loop() {
        let mut counter = 0;
        let mut total = 0;

        // Loop to increment counter and add to total
        while (counter < 10) {
            total = total + counter;
            counter = counter + 1;
        };

        // Assign new value to total
        total = total + 100;

        // Return total for verification
        return;
    }

    // Function that performs variable reassignment at different points
    public fun test_reassignment() {
        let mut value = 10;
        value = value * 2;
        value = value + 5;
        value = value / 3;
        return;
    }

    // Main function to invoke the tests
    public fun main() {
        // Call assignment and loop test
        Self::test_assignment_and_loop();

        // Call reassignment test
        Self::test_reassignment();
    }
}

//# run 0xabc::test_assignments_loops::main

//# publish
module 0xabc::test_break_in_loop {
    public fun main() {
        let mut sum = 0;
        let mut count = 0;

        // Loop with break condition
        while (true) {
            sum = sum + count;
            count = count + 1;
            if (count == 5) {
                break;
            }
        }

        // After loop, count should be 5 and sum should be 0+1+2+3+4=10
        assert!(count == 5, 0);
        assert!(sum == 10, 1);
    }
}

//# run 0xabc::test_break_in_loop::main