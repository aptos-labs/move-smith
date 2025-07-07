//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    spec module {
        static mut SPEC_VAR: u64;

        fun update_spec_var(val: u64) {
            SPEC_VAR = val;
        }
    }

    public fun call_with_args_and_generic<T: copy + drop>(x: u8, y: T): u8 {
        let _ = x + 1;
        let _ = y;
        x + 10
    }

    public fun run_update_spec_var() {
        update_spec_var(12345);
    }

    public fun get_spec_var_value(): u64 {
        // Note: Reading spec var in Move code not allowed directly,
        // so this function is for demonstration to be called in spec context.
        0
    }

    public fun byte_string_demo(): vector<u8> {
        let bytes: vector<u8> = b"Hello\x20World\x21";
        bytes
    }

    public fun hex_escape_demo(): vector<u8> {
        let hex_bytes: vector<u8> = b"\xDE\xAD\xBE\xEF";
        hex_bytes
    }
}

//# run 0xCAFE::FeatureTest::call_with_args_and_generic --args 5u8 42u8

//# run 0xCAFE::FeatureTest::run_update_spec_var

//# run 0xCAFE::FeatureTest::byte_string_demo

//# run 0xCAFE::FeatureTest::hex_escape_demo

// Featurres:
// f8a4ebf8d1d120ac25f2132d82e3ad32: Call functions or macros, with arguments and optional type parameters.
// 9c339a4f76a64549803ab3b233351947: Update specification variables using assignment syntax in spec blocks.
// d96a8f739463112ddbba53a6503c82cb: Encode arbitrary bytes into Move byte string literals using the \xXX hexadecimal escape format, where XX are two hexadecimal digits.
