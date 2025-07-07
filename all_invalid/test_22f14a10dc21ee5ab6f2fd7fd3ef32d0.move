//# publish
module 0xabcde::conditional_multiply {
    /// Function that assigns and multiplies numbers based on a condition, and calls `execute()`.
    fun compute_and_call(x: u64, y: u64, cond: bool): u64 {
        let mut a = x;
        if (cond) {
            a = y;
        };
        let result = a * 4;
        execute();
        let result2 = a * 5;
        result + result2
    }

    /// Function that calls `execute()` conditionally and in all cases.
    fun compute_with_multiple_conds(x: u64, y: u64, cond1: bool, cond2: bool): u64 {
        let mut v = x;
        if (cond1) {
            v = y;
        };
        let t = v + 1;
        if (cond2) {
            execute();
        };
        execute();
        let t2 = v + 2;
        t + t2
    }

    /// Dummy bar function which will be the target of invocation to exercise calling.
    fun execute() {
        // simulate log or assertion
        assert!(true, 100);
    }
}

//# run 0xabcde::conditional_multiply::compute_and_call --args 15 25 true
//# run 0xabcde::conditional_multiply::compute_and_call --args 15 25 false
//# run 0xabcde::conditional_multiply::compute_with_multiple_conds --args 10 20 true false
//# run 0xabcde::conditional_multiply::compute_with_multiple_conds --args 10 20 false true

//# publish
module 0xabcde::casting_tests {
    /// Function to test casting between different unsigned types.
    fun test_casts() {
        // U8 to smaller (should pass if possible, but in practice, only to same, so test safe)
        let_1 = 255u8;
        assert!((let_1 as u8) == 255u8, 900);
        // U16 to U8, within range
        let_2 = 300u16;
        // Should assert failure if out of range (simulate)
        // to test overflow, we can add code that will fail during compilation if uncommented.
        // let _f = 300u16 as u8; // expected to fail (simulate)
        // U128 to U64
        let val128 = 1000000u128;
        assert!((val128 as u64) == 1000000u64, 901);
        // U64 to U128
        let val64 = 123456u64;
        assert!((val64 as u128) == 123456u128, 902);
        // U128 to U256
        let val_large = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        assert!((val_large as u256) == val_large, 903);
        // U256 to U128
        let val_u256 = 0xFFFFFFFFFFFFFFu128;
        assert!((val_u256 as u128) == val_u256, 904);
    }
}

//# run 0xabcde::casting_tests::test_casts
//# run 0xabcde::conditional_multiply::compute_and_call --signers 0x1 --args 10 20 true
//# run 0xabcde::conditional_multiply::compute_and_call --signers 0x1 --args 10 20 false
//# run 0xabcde::conditional_multiply::compute_with_multiple_conds --signers 0x1 --args 5 15 true true
//# run 0xabcde::conditional_multiply::compute_with_multiple_conds --signers 0x1 --args 5 15 false false