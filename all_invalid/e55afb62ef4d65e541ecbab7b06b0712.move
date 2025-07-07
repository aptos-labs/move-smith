module 0xCAFE::ASTDebugAndCFG {
    use std::vector;

    // A dummy AST node struct for demonstration
    struct AstNode has copy, drop, store {
        kind: u8,
        value: u64,
    }

    // Helper function to generate verbose string representation of an AST node
    public fun ast_node_to_string(node: &AstNode): vector<u8> {
        let s: vector<u8> = vector::empty();
        vector::append(&mut s, b"AstNode { kind: ");
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
        let buf: vector<u8> = vector::empty();
        let num = n; // make mutable
        if (num == 0) {
            vector::push_back(&mut buf, b'0');
        } else {
            let digits: vector<u8> = vector::empty();
            let digits_local: vector<u8> = vector::empty();
            let temp_num = num; // use a local mutable variable
            while (temp_num > 0) {
                let d = (temp_num % 10) + b'0';
                vector::push_back(&mut digits_local, d);
                temp_num = temp_num / 10;
            }
            // reverse digits
            let len = vector::length(&digits_local);
            let i = 0;
            while (i < len) {
                let d = *vector::borrow(&digits_local, len - 1 - i);
                vector::push_back(&mut buf, d);
                i = i + 1;
            }
        }
        buf
    }

    fun u64_to_string(n: u64): vector<u8> {
        // For simplicity, implement similar to u8_to_string
        let buf: vector<u8> = vector::empty();
        let num = n; // mutable copy
        if (num == 0) {
            vector::push_back(&mut buf, b'0');
        } else {
            let digits_local: vector<u8> = vector::empty();
            let digits: vector<u8> = vector::empty();
            while (num > 0) {
                let d = (num % 10) + b'0';
                vector::push_back(&mut digits_local, d);
                num = num / 10;
            }
            // reverse digits
            let len = vector::length(&digits_local);
            let i = 0;
            while (i < len) {
                let d = *vector::borrow(&digits_local, len - 1 - i);
                vector::push_back(&mut buf, d);
                i = i + 1;
            }
        }
        buf
    }

    // Function to apply splitting critical edges in control flow graph
    public fun split_critical_edges(control_flow: &vector<u8>): vector<u8> {
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