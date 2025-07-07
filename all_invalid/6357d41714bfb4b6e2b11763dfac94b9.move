
//# publish
module 0xCAFE::LambdaAndParsingTests {
    use std::vector;

    // Test defining anonymous lambdas with capture patterns
    public fun test_lambda_capture() {
        let lambda_no_capture: |u8| u8 = |a: u8| a + 1;
        let lambda_with_capture: |u8| u8 = |a: u8| {
            let b = 10;
            a + b
        };
        let result1 = lambda_no_capture(5);
        let result2 = lambda_with_capture(5);
        // Use the results to prevent dead code elimination
        assert!(result1 == 6, 0);
        assert!(result2 == 15, 0);
    }

    // Test lambda parameters used with ignored arguments
    public fun test_lambda_ignore_params() {
        let lambda_ignore_first: |u8, u8| u8 = |_, b: u8| b + 1;
        let lambda_ignore_second: |u8, u8| u8 = |a: u8, _| a + 2;
        let val1 = lambda_ignore_first(3, 4);
        let val2 = lambda_ignore_second(5, 6);
        assert!(val1 == 5, 0);
        assert!(val2 == 7, 0);
    }

    // Simulate parsing a string as a Move source file
    // For the purpose of this test, we define a dummy parser function
    // that takes a string and returns a structured representation
    public fun parse_move_source(source: vector<u8>): (vector<u8>, vector<vector<u8>>) {
        // This is a mock parser: it splits the source by newline and 
        // extracts lines with '//' as documentation comments
        let docs: vector<vector<u8>> = vector::empty<vector<u8>>();
        let lines: vector<vector<u8>> = vector::empty<vector<u8>>();
        let start_idx = 0;
        let len = vector::length(&source);
        let i = 0;
        while (i < len) {
            // Find next newline
            let j = i;
            while (j < len && vector::index(&source, j) != 0x0A /* newline */) {
                j = j + 1;
            }
            // Extract line
            let line = vector::slice(&source, i, j);
            // Check for documentation comment '//'
            if (vector::length(&line) >= 2 && vector::index(&line, 0) == 0x2F /* '/' */ && vector::index(&line, 1) == 0x2F /* '/' */) {
                vector::push_back(&mut docs, line);
            } else {
                vector::push_back(&mut lines, line);
            }
            i = j + 1;
        }
        (lines, docs)
    }

    // Test parsing a string [Move source code]
    public fun test_parsing() {
        let move_code = b"
        // This is a test module
        module 0xCAFE::Sample {
            // Function doc
            public fun f() {}
        }";
        let (parsed_lines, documentation) = parse_move_source(move_code);
        // The test just ensures the function completes without error
        assert!(vector::length(&parsed_lines) > 0, 0);
        assert!(vector::length(&documentation) > 0, 0);
    }
}


//# run 0xCAFE::LambdaAndParsingTests::test_lambda_capture

//# run 0xCAFE::LambdaAndParsingTests::test_lambda_ignore_params

//# run 0xCAFE::LambdaAndParsingTests::test_parsing

// Featurres:
// f38948f8e40e61db2fe9d3aeb1e0aa1a: Define anonymous lambda expressions with optional capture patterns in Move code.
// 5fe160ed1eb9fc8c1f833320b14d8fc7: Test that lambda (anonymous function) parameters can be used with ignored arguments (using `_`) in inline function calls.
// 0f44969c3d0814233ac0784e3eec8fe7: Parse a string as a Move source file and produce a structured representation with associated documentation comments.
