//# publish
module 0xabcde::bitwise_shift {
    public fun test_shift_left(): bool {
        let original_value = 4; // binary 100
        let shifted_value = original_value << 2; // should be 16 (binary 10000)
        let compare_value = 16;
        shifted_value == compare_value
    }

    public fun run_shift_test() {
        assert!(test_shift_left(), 0);
    }
}

//# run 0xabcde::bitwise_shift::run_shift_test

//# publish
module 0xabcde::ref_deref {
    fun test_reference_dereference(p: u64): u64 {
        let ref1 = &p;
        let ref2 = &ref1;
        //*ref2 dereferences twice to reach original value
        *(*ref2)
    }

    public fun main() {
        let value = 99;
        let result = test_reference_dereference(value);
        assert!(result == value, 0);
    }
}

//# run 0xabcde::ref_deref::main