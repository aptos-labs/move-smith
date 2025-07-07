//# publish
module 0xabc::addition_test {
    // Function to test addition of two u8 values and return a specific value post-operation
    public fun compute_and_return(): u8 {
        let a: u8 = 100;
        let b: u8 = 55;
        // Perform addition
        let sum = a + b; // 155
        // Return a fixed value to confirm function execution
        return 42;
        // Optionally, could return sum for more detailed test
        // But per instructions, focus on calculation
    }
}

//# run 0xabc::addition_test::compute_and_return


//# run
script {
    // Define constants of various primitives and literals to verify correctness
    const U8_CONST: u8 = 255;
    const U16_CONST: u16 = 65535;
    const U32_CONST: u32 = 4294967295;
    const U64_CONST: u64 = 18446744073709551615;
    const U128_CONST: u128 = 340282366920938463463374607431768211455;
    const U256_CONST: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    const BOOL_TRUE: bool = true;
    const ADDR_EXAMPLE: address = @0x7B;
    const HEX_BYTES: vector<u8> = x"deadbeef";
    const BYTE_STRING: vector<u8> = b"test";

    fun main() {
        assert!(U8_CONST == 255, 42);
        assert!(U16_CONST == 65535, 42);
        assert!(U32_CONST == 4294967295, 42);
        assert!(U64_CONST == 18446744073709551615, 42);
        assert!(U128_CONST == 340282366920938463463374607431768211455, 42);
        assert!(U256_CONST == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 42);
        assert!(BOOL_TRUE == true, 42);
        assert!(ADDR_EXAMPLE == @0x7B, 42);
        assert!(HEX_BYTES == x"deadbeef", 42);
        assert!(BYTE_STRING == b"test", 42);
    }
}

//# publish
module 0xabc::scoping_enum {
    enum SampleEnum has drop {
        VariantA,
        VariantB { value: u64 },
        VariantC { a: u8, b: u8 },
    }

    struct Holder {
        flag: bool,
        enum_field: SampleEnum,
    }

    /// Checks that nested variable shadowing does not corrupt enum variants.
    public fun test_enum_scoping(holder: &Holder): u64 {
        let count = 0;
        {
            let count = 1; // Shadow outer count
            {
                // Match on the enum field; ensure correct variant
                match (&holder.enum_field) {
                    VariantA => {
                        // do nothing
                    }
                    VariantB { value } => {
                        // do something with value
                        *value
                    }
                    VariantC { a, b } => {
                        *a + *b as u64
                    }
                }
            }
            // This inner block ends, original count remains shadowed outside
        }
        count
    }

    pub fun run_test(): u64 {
        // Create a holder with VariantC
        let h = &mut Holder {
            flag: false,
            enum_field: SampleEnum::VariantC { a: 10, b: 20 },
        };
        // This should return 0, showing outer count is unaffected
        test_enum_scoping(h)
    }
}

//# run 0xabc::scoping_enum::run_test