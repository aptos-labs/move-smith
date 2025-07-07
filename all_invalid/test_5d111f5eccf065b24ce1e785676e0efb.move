//# publish
module 0xA650::ByteStringLiteralTests {
    //# run
    script {
        fun main() {
            // Test empty byte string literal
            assert!(b"" == x"", 0);
            // Test a simple ASCII string
            assert!(b"Hello" == x"48656c6c6f", 1);
            // Test a string with hexadecimal escape sequences
            assert!(b"\x48\x65\x6C\x6C\x6F" == x"48656c6c6f", 2);
            // Test a string with mixed ASCII and escape sequences
            assert!(b"Di\x65m" == x"4469656d", 3);
            // Test a string with only escape sequences
            assert!(b"\x00\xFF" == x"00ff", 4);
        }
    }
}