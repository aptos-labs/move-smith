//# publish
module 0x123::test_module {
    // A new function that sums 65 inputs and asserts the total is 65
    public fun check_sum(
        s0: u64, s1: u64, s2: u64, s3: u64, s4: u64, s5: u64, s6: u64, s7: u64, s8: u64, s9: u64,
        s10: u64, s11: u64, s12: u64, s13: u64, s14: u64, s15: u64, s16: u64, s17: u64, s18: u64, s19: u64,
        s20: u64, s21: u64, s22: u64, s23: u64, s24: u64, s25: u64, s26: u64, s27: u64, s28: u64, s29: u64,
        s30: u64, s31: u64, s32: u64, s33: u64, s34: u64, s35: u64, s36: u64, s37: u64, s38: u64, s39: u64,
        s40: u64, s41: u64, s42: u64, s43: u64, s44: u64, s45: u64, s46: u64, s47: u64, s48: u64, s49: u64,
        s50: u64, s51: u64, s52: u64, s53: u64, s54: u64, s55: u64, s56: u64, s57: u64, s58: u64, s59: u64,
        s60: u64, s61: u64, s62: u64, s63: u64, s64: u64,
    ) {
        let total = s0 + s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9 +
                    s10 + s11 + s12 + s13 + s14 + s15 + s16 + s17 + s18 + s19 +
                    s20 + s21 + s22 + s23 + s24 + s25 + s26 + s27 + s28 + s29 +
                    s30 + s31 + s32 + s33 + s34 + s35 + s36 + s37 + s38 + s39 +
                    s40 + s41 + s42 + s43 + s44 + s45 + s46 + s47 + s48 + s49 +
                    s50 + s51 + s52 + s53 + s54 + s55 + s56 + s57 + s58 + s59 +
                    s60 + s61 + s62 + s63 + s64;
        assert!(total == 65, 777);
    }

    // A clever test that performs addition within Move and triggers an abort intentionally
    public fun test_abort_behavior(): u8 {
        // Add two numbers and intentionally abort if sum is greater than 300
        let result = {200u8 + 100u8} + {if (true) {abort 100} else {5u8}};
        result
    }

    // Runner to execute check_sum with all inputs as 1
    public fun run_check_sum(): () {
        check_sum(
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1
        );
    }

    // Runner to execute test_abort_behavior
    public fun run_abort_test(): u8 {
        test_abort_behavior()
    }
}

//# run 0x123::test_module::run_check_sum --signers 0x1
//# run 0x123::test_module::run_abort_test --signers 0x1