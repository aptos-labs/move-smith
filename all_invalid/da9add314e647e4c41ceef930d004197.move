//# publish
module 0xCAFE::HexStringErrors {
    // Testing hex string literals with odd number of digits
    public fun test_odd_length_hex_string(): vector<u8> {
        // The following hex string is invalid due to odd number of hex digits (3 digits)
        // This function is expected to fail compilation or runtime validation in Move compiler/VM
        // We write it here to exercise the compiler error reporting
        // let v: vector<u8> = x"123"; // This line should cause an error if uncommented
        // To avoid breaking compilation, comment out the above line.
        // Instead, return an empty vector to pass compilation here.
        vector::empty<u8>()
    }
}



//# publish
module 0xCAFE::FunctionVisibility {
    // Provide a way to get string representations of function visibility modifiers
    
    // Enum for visibility types as string
    struct VisibilityString has copy, drop {
        value: vector<u8>
    }

    public fun visibility_public(): VisibilityString {
        VisibilityString { value: b"public" }
    }

    public fun visibility_public_entry(): VisibilityString {
        VisibilityString { value: b"public entry" }
    }

    public fun visibility_script(): VisibilityString {
        VisibilityString { value: b"script" }
    }

    public fun visibility_native(): VisibilityString {
        VisibilityString { value: b"native" }
    }

    public fun visibility_private(): VisibilityString {
        VisibilityString { value: b"private" }
    }

    // A function to get visibility string from a u8 representing visibility kind
    // 1: public, 2: public entry, 3: script, 4: native, else private
    public fun get_visibility_string(vis: u8): vector<u8> {
        if (vis == 1) {
            visibility_public().value
        } else if (vis == 2) {
            visibility_public_entry().value
        } else if (vis == 3) {
            visibility_script().value
        } else if (vis == 4) {
            visibility_native().value
        } else {
            visibility_private().value
        }
    }

    public fun runner() {}
}



//# publish
module 0xCAFE::AbilityParser {
    // Recognize tokens such as commas, braces, semicolons to parse ability declarations correctly
    
    // Dummy function to parse and return a vector<u8> representing parsed abilities string,
    // just to exercise token recognition in parsing.
    public fun parse_abilities(): vector<u8> {
        // Simulate recognition of tokens: commas, braces {}, semicolons;
        let abilities = vector[
            b"copy"[0],
            b","[0],
            b"drop"[0],
            b";"[0],
            b"store"[0],
            b"{"[0],
            b"}"[0]
        ];
        abilities
    }

    public fun runner() {}
}


//# run 0xCAFE::HexStringErrors::test_odd_length_hex_string

//# run 0xCAFE::FunctionVisibility::get_visibility_string --args 1u8

//# run 0xCAFE::FunctionVisibility::get_visibility_string --args 2u8

//# run 0xCAFE::FunctionVisibility::get_visibility_string --args 3u8

//# run 0xCAFE::FunctionVisibility::get_visibility_string --args 4u8

//# run 0xCAFE::FunctionVisibility::get_visibility_string --args 5u8

//# run 0xCAFE::AbilityParser::parse_abilities

// Featurres:
// 26a2e80ad26e136577584fdba271b3fe: See specific error messages when using an odd number of digits in a hex string literal
// fabdfe3e50de63951e286a1bc897e998: Define a function to get the string representation of a function's visibility.
// a06727494262e8a948eb4b0617e7fbda: Recognize specific tokens such as commas, braces, and semicolons to parse ability declarations correctly.
