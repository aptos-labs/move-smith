// # publish
address 0xCAFE {
    module AstPrinter {
        use std::debug;
        use std::string;

        struct AstNode has copy, drop, store {
            value: string::String,
            children: vector<AstNode>,
        }

        public fun new_node(value: string::String): AstNode {
            AstNode {
                value,
                children: vector::empty(),
            }
        }

        public fun add_child(parent: &mut AstNode, child: AstNode) {
            vector::push_back(&mut parent.children, child);
        }

        // Recursive printer helper
        fun print_indent(indent: u8) {
            let mut i = 0;
            while (i < indent) {
                debug::print("\u{20}"); // space
                i = i + 1;
            }
        }

        public fun print_ast(node: &AstNode) {
            print_ast_inner(node, 0);
        }

        fun print_ast_inner(node: &AstNode, indent: u8) {
            print_indent(indent);
            debug::print(&node.value);
            debug::print("\n");

            let len = vector::length(&node.children);
            let mut i = 0;
            while (i < len) {
                let child = &vector::borrow(&node.children, i);
                print_ast_inner(child, indent + 2);
                i = i + 1;
            }
        }

        // Runner to test AST print
        public fun runner() {
            let root = new_node(string::utf8(b"root"));
            let child1 = new_node(string::utf8(b"child1"));
            let child2 = new_node(string::utf8(b"child2"));
            add_child(&mut (root), child1);
            add_child(&mut (root), child2);

            let grandchild = new_node(string::utf8(b"grandchild"));
            let mut root_mut = root;
            add_child(&mut root_mut, grandchild);

            print_ast(&root_mut);
        }
    }

    module LoopReset {
        use std::debug;

        // Runner tests variable reset inside loop and retained value outside loop
        public fun runner() {
            let mut x = 100; // variable assigned outside loop

            let mut i = 0;
            while (i < 3) {
                x = 10; // reset inside loop
                debug::print("Inside loop, iteration: ");
                debug::print_int(i);
                debug::print(", x = ");
                debug::print_int(x);
                debug::print("\n");
                i = i + 1;
            }

            // After loop, x should retain last set value
            debug::print("After loop, x = ");
            debug::print_int(x);
            debug::print("\n");
        }
    }

    module UntypedLiteral {
        use std::debug;

        // Function demonstrating integer literals without type suffix
        public fun runner() {
            // Declaring untyped integer literals; compiler defaults their type to u64 in Move.
            let a = 42;
            let b = 1000 + 500;
            let c = 0; // zero literal without suffix

            debug::print("a = ");
            debug::print_int(a);
            debug::print("\n");

            debug::print("b = ");
            debug::print_int(b);
            debug::print("\n");

            debug::print("c = ");
            debug::print_int(c);
            debug::print("\n");
        }
    }
}

// # run 0xCAFE::AstPrinter::runner --signers 0xCAFE
// # run 0xCAFE::LoopReset::runner --signers 0xCAFE
// # run 0xCAFE::UntypedLiteral::runner --signers 0xCAFE

// Featurres:
// 3765ae37e3a2c5881dd022887ffb7af0: Print an abstract syntax tree (AST) node in a human-readable format for debugging purposes.
// 45cd9535577958984164ca863e5c1ac5: Test that a variable assigned outside a loop can be reset inside the loop and retains its value after multiple iterations.
// 65a8053552ea57ed62634759f6bc35f0: Write integer literals without a type suffix to have them default to an untyped integer value.
