
//# publish
module 0xCAFE::TupleAndAttrTest {
    use std::option;

    // This function tests tuple declaration with anonymous fields and attribute syntax
    // test]
    public fun test_tuple_declaration_and_attributes(x: u8, y: u8): bool {
        let tuple_var: (u8, u8) = (x, y);
        let (a, b) = tuple_var;

        // Inline attribute usage on local variable for demonstration (though Move attributes are limited)
        // inline]
        let _local_tuple: (u8, u8) = (a, b);

        // Verify that tuple elements match
        a == x && b == y
    }

    // Function testing conditional unpacking with safe fallback to None
    public fun conditional_unpack(
        input: option::Option<(u8, u8, u8)>
    ): option::Option<(u8, u8, u8)> {
        if (option::is_none(&input)) {
            option::none()
        } else {
            let (v1, v2, v3) = option::borrow(&input);
            // Perform a conditional check: if v1 + v2 is even, unpack successfully, else None
            if ((v1 + v2) % 2u8 == 0) {
                option::some((*v1, *v2, *v3))
            } else {
                option::none()
            }
        }
    }

    // Runner function to test conditional_unpack
    public fun run_conditional_unpack_success(): bool {
        let input = option::some((2u8, 4u8, 8u8));
        let result = conditional_unpack(input);
        option::is_some(&result)
    }

    public fun run_conditional_unpack_failure(): bool {
        let input = option::some((1u8, 3u8, 5u8));
        let result = conditional_unpack(input);
        option::is_none(&result)
    }
}


//# run 0xCAFE::TupleAndAttrTest::test_tuple_declaration_and_attributes --args 5u8 10u8


//# run 0xCAFE::TupleAndAttrTest::run_conditional_unpack_success


//# run 0xCAFE::TupleAndAttrTest::run_conditional_unpack_failure

// Featurres:
// 4cf2880fe87afa7d8e339827d2aa4ca1: Declare tuple types with anonymous fields in Move, using the syntax (Type1, Type2, ...), where fields are named '0', '1', etc.
// 52c9a1b5506e7c6cf267f9b531307af7: Attach attributes to your script's function definition.
// d8f18d46dd84ee9297b6e4717d1ec75b: Perform conditional unpacking of fields, returning None if any assignment fails.
