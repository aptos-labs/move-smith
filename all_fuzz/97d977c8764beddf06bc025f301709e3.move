//# publish
module 0xCAFE::ComprehensiveTargetTest {
    public fun match_enum(u: u8, b: bool, val: u64) {
        // implementation here
    }

    // test]
    public fun test_match_enum() {
        Self::match_enum(2, true, 9999);
    }
}
