//# publish
module 0xdeadbeef::addition_test {
    public fun compute_sum(a: u8, b: u8): u8 {
        // Return the sum of the two inputs plus a specific value (e.g., 10)
        (a + b) + 10
    }

    public fun run_compute_sum(): u8 {
        compute_sum(20u8, 5u8)
    }

    public fun runner() {
        let result = run_compute_sum();

        // Additional internal check: if the sum exceeds 30, return 1, else 0
        if (result > 30u8) {
            return 1;
        } else {
            return 0;
        }
    }
}

//# run 0xdeadbeef::addition_test::run_compute_sum
//# run 0xdeadbeef::addition_test::runner

//# publish
module 0xcafe::conditional_behavior {
    public fun toggle_value(input: u64, toggle: bool): u64 {
        // Return input + 100 if toggle is true, otherwise return input
        if (toggle) {
            input + 100
        } else {
            input
        }
    }

    public fun check_behavior() {
        let val_true = toggle_value(50u64, true);
        let val_false = toggle_value(50u64, false);
        
        // Fake assertions (not required to be asserted, just for demonstration)
        if (val_true != 150u64) {
            // do nothing
        }
        if (val_false != 50u64) {
            // do nothing
        }
    }
}

//# run 0xcafe::conditional_behavior::check_behavior

//# publish
module 0x0::interaction_test {
    public fun complex_interaction(x: u8, y: u8, toggle: bool): u8 {
        // Compute sum of x and y, then add 5 if toggle is true, else subtract 5
        let base = x + y;
        if (toggle) {
            base + 5u8
        } else {
            base - 5u8
        }
    }

    public fun run_interaction() {
        let val_true = complex_interaction(10u8, 20u8, true);
        let val_false = complex_interaction(10u8, 20u8, false);
        
        // Internal checks (no assertions necessary)
        if (val_true != 35u8) {
            // do nothing
        }
        if (val_false != 25u8) {
            // do nothing
        }
    }
}

//# run 0x0::interaction_test::run_interaction