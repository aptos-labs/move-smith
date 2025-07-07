//# publish
module 0xCAFE::UIntLiteralTest {
    // Test for correct interpretation of unsigned integer literals in hex across multiple sizes
    public fun test_literal_interpretation() {
        let val_u8: u8 = 0x00;             // leading zeros
        let val_u16: u16 = 0x00FF;         // max value for 8 bits
        let val_u32: u32 = 0x0000FF00;     // embedded zeros
        let val_u64: u64 = 0x000000FF;     // smaller value
        // No assertions, just variable assignments to exercise literal parsing
    }

    // Test for destruction and re-assignment in copy chain
    public fun test_copy_destroy_and_reassign() {
        let c: u64 = 12345;
        let a: u64 = c; // a copies c
        let b: u64 = a; // b copies a

        // Destroy a (simulate move)
        move_from_global::<u64>(b);
        // re-assign b to a again
        a = 67890;

        // For the purpose of testing, just do variable assignments
        // No assertions, just to test move and re-assign
    }

    // Function to simulate global move from resource, for testing destruction in move chains
    fun move_from_global<T: store + key>(value: T) {
        // No-op, placeholder to simulate move
    }

    //# run 0xCAFE::UIntLiteralTest::test_literal_interpretation
    //# run 0xCAFE::UIntLiteralTest::test_copy_destroy_and_reassign
}

// Featurres:
// 5baab59f411599ad0a4ff7f948d44fc8: Test that unsigned integer literals correctly interpret various hexadecimal representations with leading zeros across multiple integer sizes.
// 5f2ba91b946acfaef5bc1b41c3366d82: Test that destroying a variable in a copy chain with a re-assignment correctly removes all related copy information, ensuring equality comparisons use the correct values.
// 1707c8b926475d0e0b9f915ef732e905: Analyze live variables to assist in optimization passes and code correctness.
