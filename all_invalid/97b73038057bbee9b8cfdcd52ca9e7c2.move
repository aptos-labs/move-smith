
//# publish
module 0xCAFE::ParserAndInteractionTest {
    use std::assert;
    use std::vector;

    
//# EnumExtractor submodule for enum extraction functions
//# publish
    module 0xCAFE::EnumExtractor {
        use 0xCAFE::ParserAndInteractionTest::MyEnum;

        // Function to extract a u8 value from a nested enum variant with specific structure
        public fun extract_u8_from_enum(e: &MyEnum): u8 {
            match (e) {
                MyEnum::Variant1 => 1,
                MyEnum::Variant2(x, y) => {
                    // Cast u16 to u8 with truncation
                    (x as u8) + (y as u8)
                },
                MyEnum::Nested { inner } => match (inner) {
                    MyEnum::Variant1 => 2,
                    MyEnum::Variant2(x, y) => {
                        (x as u8) + (y as u8)
                    },
                    MyEnum::Nested { inner: inner_inner } => match (inner_inner) {
                        MyEnum::Variant1 => 3,
                        MyEnum::Variant2(x, y) => {
                            ((x as u8) + (y as u8)) + 10
                        },
                        _ => 0,
                    },
                    _ => 0,
                },
            }
        }
    }

    // Enum with various nested structures
    // Define the enum within the main module for clarity
    public enum MyEnum {
        Variant1,
        Variant2(u16, u16),
        Nested { inner: Box<MyEnum> },
    }

    // Inline function that calls another internal function
    public fun inline_call_with_visibility(x: u8): u8 {
        internal_helper(x)
    }

    // Internal helper function
    fun internal_helper(y: u8): u8 {
        y + 1
    }

    // Function for parsing decimal literals with digits and underscores
    public fun parse_decimal_literal(input: vector<u8>): bool {
        // Simplified parser simulation: check if all bytes are digits or underscore
        let len = vector::length(&input);
        let index = 0;
        while (index < len) {
            let c = *vector::borrows(&input, index);
            if !(
                (c >= 48 && c <= 57) // '0'..'9'
                || c == 95 // '_'
            ) {
                return false;
            }
            index = index + 1;
        }
        true
    }

    // Function to test parsing and enum extraction
    public fun test_parse_and_extract(parsing_input: vector<u8>, enum_variant: u8): u8 {
        // Parse decimal literal
        let parse_ok = parse_decimal_literal(parsing_input);
        assert!(parse_ok, 999);

        // Construct enum based on input
        let enum_value = match (enum_variant) {
            0 => MyEnum::Variant1,
            1 => MyEnum::Variant2(3, 4),
            2 => MyEnum::Nested { inner: Box::new(MyEnum::Variant2(5, 6)) },
            _ => MyEnum::Variant1,
        };

        // Extract u8 from enum
        let extracted = 0xCAFE::EnumExtractor::extract_u8_from_enum(&enum_value);
        extracted
    }

    // Test inline function calling internal helper
    public fun test_inline_function(x: u8): u8 {
        inline_call_with_visibility(x)
    }
}



//# run 0xCAFE::ParserAndInteractionTest::test_parse_and_extract --args 48u8 1


//# run 0xCAFE::ParserAndInteractionTest::test_inline_function --args 10u8
