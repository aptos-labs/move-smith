//# publish
module 0x1234::nested_call_test {
    /// A simple helper function that returns its input
    fun identity(val: u64): u64 {
        val
    }

    /// A nested function call: calls identity multiple times
    fun nested_chain(input: u64): u64 {
        identity(identity(identity(input)))
    }

    /// Generate some nested calls with different inputs
    fun run_tests() {
        // Let's store some results for different inputs
        let res1 = nested_chain(42);
        let res2 = nested_chain(100);
        let res3 = nested_chain(0);
        // For verification inside Move, assert statements could be used
        // but per instructions, assertions are ignored here.
        // The main goal is to test nested function call returns.
    }
    /// Public runner function to exercise the nested calls
    public fun run() {
        run_tests();
    }
}

//# run 0x1234::nested_call_test::run


//# publish
module 0xABCD::literal_literals {
    fun verify_literals() {
        // Numeric literals with underscores, leading zeros, hex notation
        let dec1 = 1_000u16;
        let dec2 = 0001u16;
        let hex1 = 0xffu8;
        let hex2 = 0X_FFu8; // Hex with underscores
        let bin1 = 0b1010u8;
        let bin2 = 0B_1010u8; // Binary literal with underscore (assuming supported)
        // Numeric with multiple underscores
        let num1 = 1__234u32;
        let num2 = 00_12_34u32;

        // Perform some dummy comparisons to simulate usage
        let _ = if dec1 == dec2 { true } else { false };
        let _ = if hex1 == 255u8 { true } else { false };
        let _ = if hex2 == 255u8 { true } else { false };
        let _ = if bin1 == 10u8 { true } else { false };
        let _ = if bin2 == 10u8 { true } else { false };
        let _ = if num1 == 1234u32 { true } else { false };
        let _ = if num2 == 1234u32 { true } else { false };
    }

    public fun run() {
        verify_literals();
    }
}

//# run 0xABCD::literal_literals::run