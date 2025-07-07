//# publish
module 0xCAFE::PrecedenceTest {
    use std::vector::*;
    use std::string::*;
    
    // Test 1: Complex expression parsing with precedence
    #[test]
    public fun test_precedence_expression(): bool {
        // Use i32 for handling negative values
        let a = (1 as i32);
        let b = (2 as i32);
        let c = (3 as i32);
        let d = (4 as i32);
        let e = (5 as i32);

        let sum = a + b; // 1 + 2
        let diff = c - d; // 3 - 4
        let mult = sum * diff; // (1 + 2) * (3 - 4)
        let result = mult + e; // previous result + 5

        // Validate the computation
        // Expected: (3) * (-1) + 5 = -3 + 5 = 2
        // Since function returns bool, check if result == 2
        result == 2
    }

    // Test 2: Wildcard import usage and function call
    #[test]
    public fun test_wildcard_imports(): bool {
        // Use vector::push_back via wildcard import
        let mut vec: vector<u8> = vector::empty();
        vector::push_back(&mut vec, 0x41u8); // 'A'
        vector::push_back(&mut vec, 0x42u8); // 'B'
        vector::push_back(&mut vec, 0x43u8); // 'C'
        // Check if vector is not empty
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