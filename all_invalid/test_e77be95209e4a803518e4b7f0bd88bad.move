//# publish
module 0xdeadbeef::OverflowDivisionShiftTests {
    use std::vector;

    // Function to test overflow and division by zero errors with various numeric types
    fun trigger_overflow_and_division(): () {
        // These expressions should abort during execution
        let test_vector = vector<u8>{
            1 << 8,                   // overflow u8 (shift by 8)
            255 + 1,                  // overflow u8 addition
            255 * 2,                  // overflow u8 multiplication
            1 / 0,                    // division by zero
            1 % 0,                    // modulus by zero
            (1 << 8) as u16,          // shift result cast to larger type
            1 << 32,                  // overflow/u32 shift
            4294967296,               // number exceeds u32 max
        };

        let test_vector_u16 = vector<u16>{
            1 << 16,                  // shift that overflows u16
            65535 + 1,                // overflow addition
            65535 * 2,                // overflow multiplication
            1 / 0,
            1 % 0,
        };

        let test_vector_u32 = vector<u32>{
            1 << 32,                  // shift overflows u32
            4294967295 + 1,           // overflow addition
            4294967295 * 2,           // overflow multiplication
            1 / 0,
            1 % 0,
        };

        let test_vector_u64 = vector<u64>{
            1 << 64,                  // shift overflows u64
            18446744073709551615 + 1, // overflow addition
            18446744073709551615 * 2, // overflow multiplication
            1 / 0,
            1 % 0,
        };

        // These calls should abort during execution
        vector::sum(&test_vector);
        vector::sum(&test_vector_u16);
        vector::sum(&test_vector_u32);
        vector::sum(&test_vector_u64);
    }

    // Function to test shifting with out-of-range shift amounts
    fun trigger_shift_errors() {
        let val_u8: u8 = 1;
        // Shift by more than bit width
        let _ = val_u8 << 8; // should abort
        let val_u16: u16 = 1;
        let _ = val_u16 << 16; // should abort
        let val_u32: u32 = 1;
        let _ = val_u32 << 32; // should abort
        let val_u64: u64 = 1;
        let _ = val_u64 << 64; // should abort
    }

    // Runner function that calls the above functions to trigger aborts
    public fun run_tests() {
        trigger_overflow_and_division();
        trigger_shift_errors();
    }
}

//# run 0xdeadbeef::OverflowDivisionShiftTests::run_tests --signers 0xdeadbeef