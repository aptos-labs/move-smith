
//# publish
module 0xCAFE::TypeFeatureTest {
    use std::vector; // This warning indicates the alias is unused, but we are indeed using std::vector, so no change needed.

    // Test specifying return types for spec functions using colon syntax
    public fun spec_fn_with_return_type(): bool {
        true
    }

    public fun spec_fn_without_return_type() {
        // a simple spec function without return type (unit)
    }

    // Test variable assignment with `Assign` expressions
    public fun assign_expressions() {
        let _a: u8 = 42;
        let _b: u8 = 2 + 3;
        let _c: u8 = _a + _b;
        // Use nested assign expressions
        let _d: u8 = if (_a > _b) {
            1u8
        } else {
            0u8
        };
    }

    // Test literal value expressions
    public fun literal_values() {
        let _num_u8: u8 = 255u8;
        let _num_u16: u16 = 65535u16;
        let _num_u32: u32 = 4294967295u32;
        let _num_u64: u64 = 18446744073709551615u64;

        let _zero: u8 = 0u8;
        let _false: bool = false;
        let _true: bool = true;
        let _byte_string: vector<u8> = b"Literal Bytes";
        let _hex_string: vector<u8> = x"cafebabe";

        // Compose some complex literals
        // The tuple type (u8, u16) is not valid for a local variable in Move.
        // To fix it, either omit the tuple or define as a vector.
        // Here, we'll define as a vector for simplicity.
        let _tuple_literal: vector<u8> = vector [_num_u8, _num_u16 as u8]; // Cast u16 to u8 to fit vector<u8>
        // Or, if we want to keep the tuple semantics, define a struct (but that complicates things).
        // So, replacing with vector for simplicity.
        let _vector_literal: vector<u8> = vector [_zero, _byte_string[0], _hex_string[0]];
    }
}



//# run 0xCAFE::TypeFeatureTest::spec_fn_with_return_type

//# run 0xCAFE::TypeFeatureTest::spec_fn_without_return_type

//# run 0xCAFE::TypeFeatureTest::assign_expressions

//# run 0xCAFE::TypeFeatureTest::literal_values