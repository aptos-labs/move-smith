
//# publish
module 0xCAFE::TestCaptureAndAST {
    use std::string;
    use std::vector;

    // Struct used for testing captured environment
    struct TestStruct has copy, drop {
        value: u64,
        label: vector<u8>,
    }

    // Function that captures primitive variables and struct, then returns a string representation
    public fun create_and_capture_env(val: u64, label_str: vector<u8>): (vector<u8>, vector<u8>) {
        let s = TestStruct { value: val, label: label_str };
        // Closure-like function capturing environment
        fun inner_func(x: u64, t: &TestStruct): vector<u8> {
            // Convert captured and argument data to string for debugging 
            let s_str = string::utf8(b"Captured value: ");
            string::append(&mut s_str, &string::number(*t.value as u64));
            string::append(&mut s_str, b", Label: ");
            string::append(&mut s_str, &t.label);
            string::append(&mut s_str, b", Argument: ");
            string::append(&mut s_str, &string::number(x));
            s_str
        }
        // Call inner function with specific argument
        let debug_str = inner_func(42u64, &s);
        (string::utf8_bytes(&debug_str), string::utf8_bytes(&debug_str))
    }

    // Function that converts an AST node (represented as a string) to its string representation for debugging
    public fun ast_node_to_string(node: vector<u8>): vector<u8> {
        // Simulate AST node as string
        node
    }
}


//# run 0xCAFE::TestCaptureAndAST::create_and_capture_env --signers 0xCAFE --args 100u64 b"TestLabel"

//# run 0xCAFE::TestCaptureAndAST::ast_node_to_string --signers 0xCAFE --args b"ASTNodeExample"

// Featurres:
// 65dff158b55a6f29b2a47bb6a97de359: Test that functions with captured variables (including primitives and structs) correctly retain their environment and produce expected results when invoked with specific arguments.
// 9917cac7eda764b9cf7471cf74a93e03: Ensure variable names do not match restricted names
// 21ac1e75f2dd47f51c2bfced1ce8d74d: Convert AST nodes to a string representation for debugging purposes.
