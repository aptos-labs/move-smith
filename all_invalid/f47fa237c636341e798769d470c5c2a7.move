//# publish
module 0x1::BoolAndHexTest {
    /// A function that returns true and false literals
    public fun bool_literals(): (bool, bool) {
        (true, false)
    }

    /// Decode a hex string literal into bytes and return its length and a known fixed byte
    public fun decode_hex() : (vector<u8>, u8) {
        // Hex string literal representing bytes: 0xDEADBEEF
        let bytes = b"\xDE\xAD\xBE\xEF";
        (bytes, 0xEF)
    }

    /// Runner function to exercise bool_literals and decode_hex
    public fun runner() {
        let (t, f) = bool_literals();
        let (bytes, last) = decode_hex();

        // Use the values locally to avoid dead code elimination
        let _ = t;
        let _ = f;
        let _ = last;
        let _ = bytes;
    }

    /// Function marked verify_only to be excluded by should_remove_node if compiling without verification
    #[verify_only]
    public fun only_when_verifying(): bool {
        true
    }
}
//# run 0x1::BoolAndHexTest::runner

//# run
script {
    use std::debug;

    fun main() {
        let (t, f) = 0x1::BoolAndHexTest::bool_literals();
        debug::print(&t);
        debug::print(&f);

        let (bytes, last) = 0x1::BoolAndHexTest::decode_hex();
        debug::print(&last);
        debug::print(&bytes);
    }
}