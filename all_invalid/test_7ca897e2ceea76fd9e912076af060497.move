//# publish
module 0xabc::sum_test_module {
    // Function to sum 65 u64 parameters and assert total equals 65
    public fun sum_of_parameters(
        x0: u64, x1: u64, x2: u64, x3: u64, x4: u64, x5: u64, x6: u64, x7: u64, x8: u64, x9: u64,
        x10: u64, x11: u64, x12: u64, x13: u64, x14: u64, x15: u64, x16: u64, x17: u64, x18: u64, x19: u64,
        x20: u64, x21: u64, x22: u64, x23: u64, x24: u64, x25: u64, x26: u64, x27: u64, x28: u64, x29: u64,
        x30: u64, x31: u64, x32: u64, x33: u64, x34: u64, x35: u64, x36: u64, x37: u64, x38: u64, x39: u64,
        x40: u64, x41: u64, x42: u64, x43: u64, x44: u64, x45: u64, x46: u64, x47: u64, x48: u64, x49: u64,
        x50: u64, x51: u64, x52: u64, x53: u64, x54: u64, x55: u64, x56: u64, x57: u64, x58: u64, x59: u64,
        x60: u64, x61: u64, x62: u64, x63: u64, x64: u64,
    ) {
        let total = x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 +
                    x10 + x11 + x12 + x13 + x14 + x15 + x16 + x17 + x18 + x19 +
                    x20 + x21 + x22 + x23 + x24 + x25 + x26 + x27 + x28 + x29 +
                    x30 + x31 + x32 + x33 + x34 + x35 + x36 + x37 + x38 + x39 +
                    x40 + x41 + x42 + x43 + x44 + x45 + x46 + x47 + x48 + x49 +
                    x50 + x51 + x52 + x53 + x54 + x55 + x56 + x57 + x58 + x59 +
                    x60 + x61 + x62 + x63 + x64;
        assert!(total == 65, 888);
    }
}

//# run 0xabc::sum_test_module::sum_of_parameters --args 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 --signers 0xdeadbeef

//# publish
module 0xdef::variable_sum_module {
    fun calculate_sum(): u64 {
        let a = 10;
        let b = 20;
        let c = 30;
        a + b + c
    }

    public fun main() {
        // Verify that sum of local variables equals 60
        assert!(calculate_sum() == 60, 999);
    }
}

//# run 0xdef::variable_sum_module::main --signers 0x1234

//# publish
module 0x789::lambda_interaction {
    inline fun combine_results(f: |u64, u64| u64, g: |u64, u64| u64, val1: u64, val2: u64): u64 {
        f(val1, val2) + g(val1, val2)
    }

    public fun compute(): u64 {
        combine_results(
            |x: u64, y: u64| x * 2,
            |x: u64, y: u64| y + 5,
            15, 25
        )
    }

    public fun runner() {
        // Call compute to validate lambda interactions
        assert!(compute() == (15 * 2 + 25 + 5), 1001);
    }
}

//# run 0x789::lambda_interaction::runner --signers 0xaced