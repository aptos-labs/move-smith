//# publish
module 0xDEAD::TupleExpressionTest {
    use std::vector;

    // Simple test with multiple expressions in parentheses
    public fun test_expression_list_in_parentheses() {
        let a = 1u8;
        let b = 2u8;
        let c = 3u8;

        let (x, y, z) = (a + 1, b + 2, c + 3);
        // Use last expression as return value
        (x, y, z)
    }

    // Create format buffer with diagnostic messages
    public fun generate_diagnostic_buffer(): vector<u8> {
        let buffer: vector<u8> = vector::empty<u8>();

        // Append a formatted message
        vector::push_back(&mut buffer, b"Diagnostic: error code ".len() as u8);
        vector::append(&mut buffer, b"12345");
        vector::push_back(&mut buffer, 0x0A); // newline

        // Append another message with parameterized attribute
        let message = b"Warning: value ";
        vector::append(&mut buffer, message);
        vector::append(&mut buffer, b"42");
        vector::push_back(&mut buffer, 0x0A); // newline

        // Append nested attribute-like message
        let nested_msg = b"Nested attribute: [level=2, reason='overflow']";
        vector::append(&mut buffer, nested_msg);
        // Buffer returned as last expression
        buffer
    }

    // Use parameterized attribute with nested attribute lists
    // move_attr(
    //     nesting_level = 3,
    //     params = [
    //         { key = "type", value = "U8" },
    //         { key = "status", value = "ok" }
    //     ],
    //     inner_attrs = [
    //         { code = "A" },
    //         { code = "B" }
    //     ]
    // )
    // move_attr(
        nesting_level = 3,
        params = [
            { key = "type", value = "U8" },
            { key = "status", value = "ok" }
        ],
        inner_attrs = [
            { code = "A" },
            { code = "B" }
        ]
    )]
    public fun attribute_with_nested_lists() {
        // The function body can be empty
        ()
    }

    // Function to call above attribute
    public fun run_attribute_test() {
        // Call the annotated function
        attribute_with_nested_lists()
    }
}


//# run 0xDEAD::TupleExpressionTest::test_expression_list_in_parentheses

//# run 0xDEAD::TupleExpressionTest::generate_diagnostic_buffer

//# run 0xDEAD::TupleExpressionTest::run_attribute_test
