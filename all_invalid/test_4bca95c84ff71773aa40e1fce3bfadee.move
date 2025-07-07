//# publish
module 0xabc::calc {
    fun get_ten(): u64 {
        10
    }

    fun get_twenty(): u64 {
        20
    }

    public fun assign_and_return(): u64 {
        let x = get_ten();
        let y = get_twenty();
        let sum = x + y;

        // Assign a new value to x
        x = get_twenty();

        // Return the updated x
        x
    }

    public fun run_test(): u64 {
        assign_and_return()
    }
}

//# run 0xabc::calc::run_test

//# publish
module 0xdef::diff_calculation {
    // Calculates the sum of the first n natural numbers
    public fun sum(n: u64): u64 {
        (n * (n + 1)) / 2
    }

    // Calculates the sum of squares of first n natural numbers
    public fun sum_of_squares(n: u64): u64 {
        let mut total = 0;
        let mut i = 1;
        while (i <= n) {
            total = total + (i * i);
            i = i + 1;
        };
        total
    }

    // Calculates the difference between square of sum and sum of squares
    public fun compute_difference(n: u64): u64 {
        let s = sum(n);
        (s * s) - sum_of_squares(n)
    }

    public fun test_difference() {
        assert!(compute_difference(10) == 2640, 0);
        assert!(compute_difference(100) == 25164150, 1);
    }
}

//# run 0xdef::diff_calculation::test_difference

//# publish
module 0x123::short_circuit {
    public fun error(): bool {
        abort 99
    }

    public fun test_short_circuit() {
        let false_val = false;
        let true_val = true;

        // Check that error() is not called when left operand is true for OR
        true || error();
        // Check that error() is not called when left operand is false for AND
        false && error();

        // The following lines ensure error() is not called due to short-circuit
        // even if error() would have aborted if called

        // Using block to prevent execution
        { let r = true; r } || error();
        { let r = false; r } && error();

        // Additional complex expression with short circuit
        if (true || error()) {
            // do nothing
        }

        if (false && error()) {
            // do nothing
        }
    }
}

//# run 0x123::short_circuit::test_short_circuit