//# publish
module 0xCAFE::StringLiterals {
    public fun string_examples() {
        let byte_string: vector<u8> = b"Hello\nWorld";
        let hex_string: vector<u8> = x"deadbeef";
    }
}