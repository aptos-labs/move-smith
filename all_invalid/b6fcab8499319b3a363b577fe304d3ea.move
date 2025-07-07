address 0x1 {
module TestTxnFeatures {
    use std::signer;
    use std::vector;

    /// A helper function to increment a u64 value by a mut ref
    fun add_one(ref x: &mut u64) {
        *x = *x + 1;
    }

    /// Function to demonstrate arithmetic and mutable references
    public fun arithmetic_and_refs(): u64 {
        // Local mutable variable
        let mut val: u64 = 10;

        // Increment val by 5 using direct arithmetic
        val = val + 5;

        // Use the helper to add one via mutable ref
        add_one(&mut val);

        // Multiple increments grouped in a loop for demonstration
        let mut i = 0;
        while (i < 3) {
            add_one(&mut val);
            i = i + 1;
        };
        val
    }

    /// Write a function that returns a byte vector from a hex string literal
    public fun get_hex_bytes(): vector<u8> {
        // hex literal "0x48656c6c6f" corresponds to ASCII "Hello"
        0x48656c6c6f
    }

    /// Module-level spec block grouping one or more specs
    spec module {
        // Constant hex bytes for assertion
        const HELLO_HEX: vector<u8> = 0x48656c6c6f;

        /// Spec: The hex literal must equal the constant HELLO_HEX
        fun spec_get_hex_bytes() {
            let v = get_hex_bytes();
            assert!(v == HELLO_HEX, 1);
        }

        /// Spec: arithmetic_and_refs returns expected value: 10 + 5 + 1 + 3 (in increments) = 19
        fun spec_arithmetic_and_refs() {
            let result = arithmetic_and_refs();
            assert!(result == 19, 2);
        }
    }

    #[test_only]
    public fun test_all(): bool {
        // test get_hex_bytes returns correct vector
        let v = get_hex_bytes();
        assert!(vector::length(&v) == 5, 100);

        // Check arithmetic_and_refs logic
        let val = arithmetic_and_refs();
        assert!(val == 19, 101);

        true
    }
}
}

// Featurres:
// cc16bed9de34d2cd2f86b207d5a4cf6d: Write hexadecimal string literals that are automatically converted to byte vectors in Move code
// b44775bbdd8e5ba940595bad7170c885: Group one or more specification block members inside a module-level spec block
// 40e9b604023b26824a1ede5bb925b701: Test that functions can perform arithmetic operations and handle mutable references by modifying local variables and passing references to other functions.
