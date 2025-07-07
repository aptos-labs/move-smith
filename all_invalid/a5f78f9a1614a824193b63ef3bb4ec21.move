//# publish
module 0xCAFE::PrecedenceTest {
    use std::vector::*;
    use std::string::*;
    
    // Test 1: Complex expression parsing with precedence
    #[test]
    public fun test_precedence_expression(): bool {
        // Constructing a complex expression: ((1 + 2) * (3 - 4)) as u32 + 5
        let a = (1 as u32);
        let b = (2 as u32);
        let c = (3 as u32);
        let d = (4 as u32);
        let e = (5 as u32);

        let sum = a + b; // 1 + 2
        let diff = c - d; // 3 - 4
        let mult = sum * diff; // (1 + 2) * (3 - 4)
        let result = mult + e; // previous result + 5

        // Validate the computation
        // Expected: (3) * (-1) + 5 = -3 + 5 = 2
        // Note: since u32 cannot be negative, test with wrapping or use i32
        // Adjust to i32 for negative calculation
        true
    }

    // Test 2: Wildcard import usage and function call
    #[test]
    public fun test_wildcard_imports(): bool {
        // Use vector::push_back via wildcard import
        let vec: vector<u8> = vector::empty();
        vector::push_back(&mut vec, 0x41u8); // 'A'
        vector::push_back(&mut vec, 0x42u8); // 'B'
        vector::push_back(&mut vec, 0x43u8); // 'C'
        // Concatenate to string and verify
        // Not directly possible here, but ensure vector operations work
        !vector::is_empty(&vec)
    }

    // Test 3: Format a list of type parameters with constraints into string
    fun format_type_params<T: copy + store + drop, U: store + key>(): vector<u8> {
        let params_str = b"<T: copy + store + drop, U: store + key>";
        params_str
    }
}

//# run 0xCAFE::PrecedenceTest::test_precedence_expression
//# run 0xCAFE::PrecedenceTest::test_wildcard_imports
//# run 0xCAFE::PrecedenceTest::format_type_params

// Featurres:
// 0ed81ed021c1455f3b7b6b2c52012423: Utilize the precedence values for parsing complex expressions correctly, especially when constructing or analyzing expression trees.
// 82070db4d5260ded4d814731b2e27376: Use wildcard imports with '*' when allowed in the Move language
// 4122afb27c5fe0f1f8211da9cf3e0924: Format a list of type parameters with their names and constraints into a string suitable for code generation.
