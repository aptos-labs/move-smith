//# publish
module 0xabc::VectorHexComparison {
    use std::vector;

    /// Test that a 33-byte vector with the high bit set is equal to its hex representation,
    /// ensuring proper handling of non-canonical byte sequences.
    //# publish
    public fun test_non_canonical_high_bit() {
        // Define a 33-byte vector with the highest bit set in the last byte
        let non_canonical_highbit = vector![0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128];

        // Corresponding hex string representation
        let hex_str = "0000000000000000000000000000000000000000000000000000000000000080";

        // Convert hex string to byte vector
        let mut hex_bytes = vector::empty<u8>();
        let mut i = 0;
        while (i < vector::length(hex_str) / 2) {
            let high_char = *vector::borrow(&hex_str, i * 2);
            let low_char = *vector::borrow(&hex_str, i * 2 + 1);
            let byte = hex_char_to_byte(high_char) * 16 + hex_char_to_byte(low_char);
            vector::push_back(&mut hex_bytes, byte);
            i = i + 1;
        }

        // Assert that the byte vector matches the hex representation
        assert!(non_canonical_highbit == hex_bytes, 1);
    }

    /// Helper function to convert a hex character to its byte value
    fun hex_char_to_byte(c: u8): u8 {
        if (c >= b'0' && c <= b'9') {
            c - b'0'
        } else if (c >= b'a' && c <= b'f') {
            c - b'a' + 10
        } else if (c >= b'A' && c <= b'F') {
            c - b'A' + 10
        } else {
            0
        }
    }

    /// Test parsing of a vector containing a high bit byte and verifying equality with its explicit hex form
    //# run
    public fun run_tests() {
        test_non_canonical_high_bit();
    }
}

    //# run 0xabc::VectorHexComparison::run_tests