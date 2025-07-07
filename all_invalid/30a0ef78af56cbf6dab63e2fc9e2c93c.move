
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
        // Inline function to simulate closure
        // Note: Move does not support nested function definitions directly.
        // To mimic inner_func, define a public inline function outside, or just inline the code here.
        // For simplicity, we inline the logic directly in create_and_capture_env.
        let s_str = string::utf8(b"Captured value: ");
        string::append(&mut s_str, &string::number(s.value));
        string::append(&mut s_str, b", Label: ");
        string::append(&mut s_str, &s.label);
        string::append(&mut s_str, b", Argument: ");
        string::append(&mut s_str, &string::number(42u64));
        (string::utf8_bytes(&s_str), string::utf8_bytes(&s_str))
    }

    // Function that converts an AST node (represented as a string) to its string representation for debugging
    public fun ast_node_to_string(node: vector<u8>): vector<u8> {
        // Simulate AST node as string
        node
    }
}



//# run 0xCAFE::TestCaptureAndAST::create_and_capture_env --signers 0xCAFE --args 100u64 b"TestLabel"


//# run 0xCAFE::TestCaptureAndAST::ast_node_to_string --signers 0xCAFE --args b"ASTNodeExample"