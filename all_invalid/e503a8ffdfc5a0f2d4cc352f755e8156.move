
//# publish
module 0xCAFE::ComprehensiveTest {
    use std::vector;
    use std::debug;

    // Struct for testing move semantics
    struct Data has copy, drop, store {
        value: u64,
        info: bool,
    }

    // Function to execute the complex test
    public fun run_comprehensive() {
        // Create a Data struct
        let d1 = Data { value: 42, info: true };
        // Move d1 to d2
        let d2 = d1;
        // Move d2 to d3
        let d3 = d2;
        // Obtain a mutable reference to 'value' field
        let d_mut: &mut Data = &mut d3;

        // Modify through the mutable reference
        d_mut.value = 100;

        // Access the field through another variable to check if still accessible
        let val_ref: &u64 = &d3.value;

        // To verify, we can assert the value is changed
        assert!(*val_ref == 100, 999);

        // AST filtering - simulate verification function that filters nodes
        // (In actual compiler tests, AST filtering would be checked during parsing,
        // but here we simulate by filtering a vector of nodes.)
        let nodes: vector<u8> = vector![1, 2, 3, 4, 5];

        // Define a filter function that only allows even numbers
        fun filter_nodes(n: u8): bool {
            n % 2 == 0
        }

        // Filter nodes
        let filtered_nodes = vector::filter(&nodes, |n| filter_nodes(*n));

        // Verify filtered result contains only evens
        let len = vector::length(&filtered_nodes);
        let i: u64 = 0;
        while (i < len) {
            let node = *vector::borrow(&filtered_nodes, i);
            assert!((node % 2) == 0, 888);
            i = i + 1;
        };

        // Simulate parser token consumption: assume function 'consume_token' skips a token.
        // Here, we simulate by advancing an index in a token vector.
        let tokens: vector<u8> = vector![b'{', b' ', b'a', b'=', b' ', b'1', b';', b'}'];
        let index: u64 = 0;

        fun consume_token(token_vec: &vector<u8>, idx: &mut u64, expected: u8) {
            let t = *vector::borrow(token_vec, *idx);
            assert!((t == expected), 777);
            *idx = *idx + 1;
        }

        // Consume the opening brace '{'
        consume_token(&tokens, &mut index, b'{');

        // Parse variable assignment (simulate)
        // Skip whitespace
        while (index < vector::length(&tokens) && *vector::borrow(&tokens, index) == b' ') {
            index = index + 1;
        };
        // Assume parse identifier 'a' (skip over the characters)
        index = index + 1; // 'a'
        index = index + 1; // '='
        // Skip space
        if (*vector::borrow(&tokens, index) == b' ') { index = index + 1; }
        // Parse value '1'
        index = index + 1; // '1'
        // Skip space before semicolon
        if (*vector::borrow(&tokens, index) == b' ') { index = index + 1; }
        // Consume semicolon ';'
        consume_token(&tokens, &mut index, b';');
        // Consume closing brace '}'
        consume_token(&tokens, &mut index, b'}');

        // At the end, the parser index should be at the end of tokens
        assert!(index == vector::length(&tokens), 999);
    }

    // Entry function to run all tests
    public fun run_all() {
        run_comprehensive();
    }
}


//# run 0xCAFE::ComprehensiveTest::run_all


// Featurres:
// 55401a24ffdc0ca1f02ebd60ec152d5f: Test that taking a mutable reference to a field after multiple moves of a struct (using let bindings) does not prevent access to the original value through another variable.
// 94c414d896fd044e3e113f97fb8b963e: Apply AST filtering for verification purposes.
// d93aadf208605e460e79121d70051fb8: Use the 'consume_token' function to advance the parser past a specified token during syntax analysis.
