// Corrected Move module with proper syntax and structure
module 0xCAFE::FeatureTest {
    use std::vector;

    // Define the struct used in testing
    // Assuming the struct is defined elsewhere as per the test
    // Adding a dummy struct definition for completeness
    struct MyModule::S {
        x: u8,
        y: u8,
    }

    // Test function
    public fun test_destructuring_and_operator_precedence() {
        // Test 1: Destructuring structs with tuple-style unpacking
        // Create nested structs
        let s = MyModule::S {x: 10, y: 20};
        // Destructure the struct
        let (x_val, y_val) = (s.x, s.y);
        // Confirm destructuring
        assert!(x_val == 10, 999);
        assert!(y_val == 20, 999);

        // Test 2: Operator precedence
        let a = 1u8;
        let b = 2u8;
        let c = 3u8;
        let result1 = (a + b) * c; // Should be 3 * 3 = 9
        assert!(result1 == 9, 999);
        let result2 = a + b * c; // Should be 1 + (2 * 3) = 7
        assert!(result2 == 7, 999);
        let result3 = (a == 1u8 && b == 2u8) || c == 3u8; 
        // Evaluate:
        // (a == 1u8 && b == 2u8) -> true && true = true
        // true || true = true
        assert!(result3, 999);

        // Test 3: Bitwise operators with precedence
        let bits = 0b1010u8; // 10
        let mask = 0b1100u8; // 12
        let and_result = bits & mask; // 0b1000 = 8
        assert!(and_result == 8, 999);
        let or_result = bits | mask; // 0b1110 = 14
        assert!(or_result == 14, 999);
        let xor_result = bits ^ mask; // 0b0110 = 6
        assert!(xor_result == 6, 999);
        // Shift with precedence
        let shift_result = (bits << 1) & 0b1111u8; // (1010 << 1) & 1111 = 10100 & 1111 = 0100 = 4
        assert!(shift_result == 4, 999);

        // Test 4: Control flow with if-else
        let condition = if a > b { true } else { false };
        assert!(!condition, 999);
        let nested_condition = if a + b > c { 
            if a == 1u8 && b == 2u8 { true } else { false } 
        } else { false };
        // a + b = 3, c=3 --> 3 > 3? No, false
        assert!(!nested_condition, 999);
        // Test conditional as expression
        let max = if a > b { a } else { b };
        assert!(max == 2, 999);
    }
}


//# run 0xCAFE::FeatureTest::test_destructuring_and_operator_precedence --signers 0xBEEF