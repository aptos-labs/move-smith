
//# publish
module 0xCAFE::TypeFeatureTest {
    use std::vector;

    // Test specifying return types for spec functions using colon syntax
    public fun spec_fn_with_return_type(): bool {
        true
    }

    public fun spec_fn_without_return_type() {
        // a simple spec function without return type (unit)
    }

    // Test variable assignment with `Assign` expressions
    public fun assign_expressions() {
        let _a = 42u8;
        let _b = 2 + 3;
        let _c = _a + _b;
        // Use nested assign expressions
        let _d = if (_a > _b) {
            1u8
        } else {
            0u8
        };
    }

    // Test literal value expressions
    public fun literal_values() {
        let _num_u8 = 255u8;
        let _num_u16 = 65535u16;
        let _num_u32 = 4294967295u32;
        let _num_u64 = 18446744073709551615u64;

        let _zero = 0u8;
        let _false = false;
        let _true = true;
        let _byte_string: vector<u8> = b"Literal Bytes";
        let _hex_string: vector<u8> = x"cafebabe";

        // Compose some complex literals
        let _tuple_literal = (_num_u8, _num_u16);
        let _vector_literal: vector<u8> = vector [_zero, _byte_string[0], _hex_string[0]];
    }
}


//# run 0xCAFE::TypeFeatureTest::spec_fn_with_return_type

//# run 0xCAFE::TypeFeatureTest::spec_fn_without_return_type

//# run 0xCAFE::TypeFeatureTest::assign_expressions

//# run 0xCAFE::TypeFeatureTest::literal_values

// Featurres:
// ac5550c3dc0faea9883b6ddb91b73e4a: Specify return types for spec functions using the colon syntax, or fall back to unit return if omitted.
// f4e30cc9e9519cf1b7ee32cdb8f66aa8: Assign values to variables with `Assign` expressions.
// c80a3f6edf8077f368cb14faf5c1c53e: Write literal value expressions (e.g., numbers, booleans) in your code.
