
//# publish
module 0xCAFE::ASTDebugAndCFG {
    use std::vector;

    // A dummy AST node struct for demonstration
    struct AstNode has copy, drop, store {
        kind: u8,
        value: u64,
    }

    // Helper function to generate verbose string representation of an AST node
    public fun ast_node_to_string(node: &AstNode): vector<u8> {
        let s: vector<u8> = b"AstNode { kind: ";
        let kind_str = u8_to_string(node.kind);
        vector::append(&mut s, kind_str);
        vector::append(&mut s, b", value: ");
        let value_str = u64_to_string(node.value);
        vector::append(&mut s, value_str);
        vector::append(&mut s, b" }");
        s
    }

    fun u8_to_string(n: u8): vector<u8> {
        // Convert u8 to string (simple implementation)
        let buf = vector::empty<u8>();
        let num = n;
        if (num == 0) {
            vector::push_back(&mut buf, b'0');
        } else {
            let digits: vector<u8> = vector::empty();
            while (num > 0) {
                let d = (num % 10) + b'0';
                vector::push_back(&mut digits, d);
                num = num / 10;
            }
            // reverse digits
            let len = vector::length(&digits);
            let i = 0;
            while (i < len / 2) {
                let temp = vector::borrow(&digits, i);
                let temp2 = vector::borrow_mut(&mut digits, i);
                *temp2 = *vector::borrow(&digits, len - 1 - i);
                let temp2_orig = vector::borrow_mut(&mut digits, len - 1 - i);
                *temp2_orig = *temp;
                i = i + 1;
            }
            vector::append(&mut buf, &digits);
        }
        buf
    }

    fun u64_to_string(n: u64): vector<u8> {
        let buf = vector::empty<u8>();
        let num = n;
        if (num == 0) {
            vector::push_back(&mut buf, b'0');
        } else {
            let digits: vector<u8> = vector::empty();
            while (num > 0) {
                let d = (num % 10) + b'0';
                vector::push_back(&mut digits, d);
                num = num / 10;
            }
            // reverse digits
            let len = vector::length(&digits);
            let i = 0;
            while (i < len / 2) {
                let temp = vector::borrow(&digits, i);
                let temp2 = vector::borrow_mut(&mut digits, i);
                *temp2 = *vector::borrow(&digits, len - 1 - i);
                let temp2_orig = vector::borrow_mut(&mut digits, len - 1 - i);
                *temp2_orig = *temp;
                i = i + 1;
            }
            vector::append(&mut buf, &digits);
        }
        buf
    }

    // Function to apply splitting critical edges in control flow graph
    public fun split_critical_edges(control_flow: &vector<u8>) -> vector<u8> {
        // For demonstration, simply insert a marker 'S'
        let new_control_flow: vector<u8> = vector::empty();
        let len = vector::length(control_flow);
        let i = 0;
        while (i < len) {
            vector::push_back(&mut new_control_flow, *vector::borrow(control_flow, i));
            // simulate splitting critical edge between nodes with value 1 and 2
            if (*vector::borrow(control_flow, i) == 1u8) {
                vector::push_back(&mut new_control_flow, b'S');
            }
            i = i + 1;
        }
        new_control_flow
    }

    // Function to test safe vector copy/move in control structures
    public fun vector_move_in_flow() {
        let vec: vector<u8> = b"abc";

        // Loop with control flow
        let i = 0;
        let len = vector::length(&vec);
        while (i < len) {
            if (i == 1) {
                // Take reference inside loop
                let _ref_vec: &vector<u8> = &vec;

                // Attempt to move vector within loop with control flow alterations
                if (i == 1) {
                    // simulate continue
                    i = i + 1;
                    continue;
                } else if (i == 2) {
                    // simulate break
                    break;
                } else if (i == 3) {
                    // simulate abort
                    abort 999;
                }
            }
            i = i + 1;
        }
        // move vector outside loop to verify no invariant violation
        let moved_vec = vec;
        // use moved_vec to prevent compiler warnings
        let _ = vector::length(&moved_vec);
    }
}


//# run 0xCAFE::ASTDebugAndCFG::ast_node_to_string --args 5u8 12345u64

//# run 0xCAFE::ASTDebugAndCFG::split_critical_edges --args 1u8 2u8 3u8

//# run 0xCAFE::ASTDebugAndCFG::vector_move_in_flow

// Featurres:
// 4c1b162e569b5e6adfd7418625892667: Generate a verbose string representation of an Abstract Syntax Tree (AST) node for debugging purposes.
// 6d6cd2f7a5512a80ae044228facb41eb: Split critical edges in control flow graphs for better analysis and transformations.
// ad9d92aeb397df9e0305ba010ef71aca: Test that a vector can be safely copied and moved after taking a reference to it inside a loop with control flow statements like break, continue, and abort without causing invariant violations.
