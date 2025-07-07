
//# publish
module 0xBABE::SyntaxErrorDetection {
    // This module intentionally contains syntax errors for validation.

    // Missing semicolon after a property in a struct
    struct IncompleteStruct {
        x: u64
        y: u64,
    }

    // Wrong use of curly braces in enum variants
    enum BadEnum {
        Variant1,
        Variant2 { a: u8, b: u8 } // Correct syntax for struct-like variant
        Variant3 (u8, u8) // Correct tuple-like variant
    }

    // Missing comma separating tuple variants
    enum MissingComma {
        V1,
        V2 (u8 u8) // Should be u8, u8
    }

    // Incorrect syntax in function body: missing token
    public fun faulty_function(x: u8): u8 {
        let y = x + 1 // missing semicolon or closing brace should cause syntax error
    }

    // Using address with an invalid syntax
    // Note: The following is intended to cause a syntax error during parsing.
    // Incorrect address literal
    public fun test_address() {
        let _ = 0xBAD; // Should be 0xBABE (correct address for test)
        // Invalid address format
        let addr = 0xGHIJ; // Invalid hexadecimal literal
    }
}


//# run
// Attempt to compile the syntax error detection module to produce parser errors

// Featurres:
// 2ee7e9c6ec65f7f18bd99ccef989791c: Declare members (such as properties, asserts, or invariants) inside spec blocks to define behaviors and checks for Move code elements.
// bd8e82f34f0f261971c335bd9fb5756d: Cause the parser to produce a syntax error if an expected token is missing, helping catch mistakes like missing punctuation or incorrect syntax in Move code.
// dfcd98ac9f2f7d5b2a6467540fe5b143: Write code that can reference both numerical (anonymous) and named addresses in address positions
