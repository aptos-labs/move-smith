
//# publish
module 0xCAFE::VarAssignmentTest {
    use std::signer;

    // Script function that assigns variables via pattern matching
    public entry fun script_pattern_assignment(s: signer) {
        // Pattern assignment with tuples
        let (a, b, c) = (1u8, 2u8, 3u8);
        // Pattern assignment with struct fields, assuming a struct:
        // Since no struct is defined, just demonstrate tuple assignment
        // Variable `a` and `b` should be marked as assigned, `c` too.
        // For variables not previously bound, they are created.
        
        // Assign a new variable with pattern
        let (x, y) = (10u16, 20u16);
        // Assign to a mutable variable by shadowing (Move variables are immutable by default)
        // Replace `x` and `y` with new values
        let x = x + 1;
        let y = y + 2;

        // Use variables to perform some dummy transaction
        let sum = a as u16 + x + y;
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

// Featurres:
// 86d48cb4e19bc09d4e4cb8649394fadc: Define script functions to act as the main function for transaction scripts
// 5fc7c03fb100cc78231369da3d433efb: Perform assignments to variables bound in patterns and have the compiler detect which variables are assigned (thus, potentially modified).
// 5b21b06461f9c3e8984db547ae8cb06a: Declare function return types, defaulting to '()' if unspecified.
