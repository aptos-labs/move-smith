
//# publish
module 0xCAFE::VarAssignmentTest {
    use std::signer;

    // Script function that assigns variables via pattern matching
    public entry fun script_pattern_assignment(s: signer) {
        // Pattern assignment with tuples
        let (a, b, c) = (1u8, 2u8, 3u8);
        // Pattern assignment with tuple
        let (x, y) = (10u16, 20u16);
        // Shadow variables with new values
        let x = x + 1;
        let y = y + 2;

        // Use variables to perform some dummy transaction
        let sum = (a as u16) + x + y; // Add parentheses to ensure correct parsing
        // No assertion, just variable assignments
    }

    // Function with explicit return type
    public entry fun script_return_type(s: signer): u64 {
        let x = 42u64;
        // function returns x
        x
    }

    // Function with default return type '()' (unit)
    public entry fun script_void(s: signer) {
        let value = 100u8;
        // No return value needed
    }

    // Additional script to test pattern destructuring with different patterns
    public entry fun complex_pattern(s: signer) {
        let (a, (b, c)) = (1u8, (2u8, 3u8));
        // All variables a, b, c are assigned
    }
}



//# run 0xCAFE::VarAssignmentTest::script_pattern_assignment --signers 0xBABB



//# run 0xCAFE::VarAssignmentTest::script_return_type --signers 0xBABB



//# run 0xCAFE::VarAssignmentTest::script_void --signers 0xBABB



//# run 0xCAFE::VarAssignmentTest::complex_pattern --signers 0xBABB