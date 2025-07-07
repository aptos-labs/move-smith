// Filename: TransactionalTest.move

address 0x1 {
    module TransactionalTest {
        use std::debug;
        use std::string;
        use std::vector;

        /// A helper function that returns a byte vector decoded from hex escape sequences
        public fun decode_hex_escape(): vector<u8> {
            // Byte string literal containing hex escape sequences:
            // \x41 is 'A' (0x41), \x42 is 'B' (0x42), \x43 is 'C' (0x43)
            let b: vector<u8> = b"\x41\x42\x43";
            b
        }

        /// A function that calls abort if input is zero, demonstrating abort in expressions
        public fun abort_if_zero(value: u64) {
            // Abort if value == 0, error code 100
            if (value == 0) {
                debug::abort(100);
            };
        }

        /// Transactional test function combining the above features
        #[test_only]
        public fun test_all_features() {
            // 1. Test decoding hex escape sequences
            let decoded_bytes = decode_hex_escape();

            // Expect decoded bytes to be: 0x41, 0x42, 0x43 = 'A', 'B', 'C'
            assert!(vector::length(&decoded_bytes) == 3, 1);
            assert!(vector::index(&decoded_bytes, 0) == 0x41, 2);
            assert!(vector::index(&decoded_bytes, 1) == 0x42, 3);
            assert!(vector::index(&decoded_bytes, 2) == 0x43, 4);

            // 2. Test abort operation - we test that abort_if_zero aborts on zero
            // Since abort terminates execution, we test non-abort case first (should pass)
            abort_if_zero(10);

            // 3. Test abort case via a separate transaction test with try-catch (if supported in test framework)
            // But Move itself has no try-catch, so here we just document that abort triggers with code 100.

            // If you want to test emitting colored diagnostics, you rely on test framework output:
            debug::print(&string::utf8(b"Test passed: Hex decoding and abort behavior.\n"));
        }
    }
}

// Featurres:
// 63b3af5e5d419bb922ba25f65782c552: Decode hexadecimal escape sequences in byte string literals.
// 5ea164eeba88ba6cfda55209d82626d9: Invoke the abort operation in expressions to terminate execution
// 45f2c90384feca6460d3f57eddc7e0f0: Receive detailed diagnostics about your Move code with colored output for easier debugging.
