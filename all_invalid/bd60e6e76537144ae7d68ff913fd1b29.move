//# publish
module 0xCAFE::AstDebug {
    use std::string;
    use std::vector;
    use std::signer;

    enum AstNode has copy, drop, store {
        Leaf(u8),
        Unary(Box<AstNode>),
        Binary(Box<AstNode>, Box<AstNode>),
    }

    public fun make_sample_ast(): AstNode {
        // Create an AST for (1 + (2))
        let leaf1 = AstNode::Leaf(1u8);
        let leaf2 = AstNode::Leaf(2u8);
        let unary = AstNode::Unary(Box::new(leaf2));
        AstNode::Binary(Box::new(leaf1), Box::new(unary))
    }

    // Use temporary expressions for intermediate string creations
    fun ast_to_str_rec(node: &AstNode): vector<u8> {
        match node {
            AstNode::Leaf(v) => {
                let s = string::utf8(b"Leaf(");
                let digit_str = digit_to_string(*v);
                let s2 = string::utf8(b")");
                let temp = string::concat(s, digit_str);
                string::concat(temp, s2)
            }
            AstNode::Unary(inner) => {
                let s = string::utf8(b"Unary(");
                let inner_str = ast_to_str_rec(&*inner);
                let s2 = string::utf8(b")");
                let temp = string::concat(s, inner_str);
                string::concat(temp, s2)
            }
            AstNode::Binary(left, right) => {
                let s = string::utf8(b"Binary(");
                let left_str = ast_to_str_rec(&*left);
                let s2 = string::utf8(b", ");
                let right_str = ast_to_str_rec(&*right);
                let s3 = string::utf8(b")");
                let temp1 = string::concat(s, left_str);
                let temp2 = string::concat(temp1, s2);
                let temp3 = string::concat(temp2, right_str);
                string::concat(temp3, s3)
            }
        }
    }

    // Helper function to convert digit (0-9) to string vector<u8>
    fun digit_to_string(d: u8): vector<u8> {
        // Only supports digits 0-9 for simplicity
        let ascii_zero = 48u8;
        let c = ascii_zero + d;
        vector::singleton(c)
    }

    public fun ast_to_string(node: &AstNode): vector<u8> {
        ast_to_str_rec(node)
    }

    // Function that will acquire a resource from address, but intentionally does not specify acquires
    // relying on the compiler to infer the missing acquires attribute (requires Move 2.2+)
    struct DummyResource has key, store {
        val: u8,
    }

    public fun store_dummy(s: signer, val: u8) {
        let r = DummyResource { val };
        move_to<DummyResource>(&s, r);
    }

    public fun read_dummy(addr: address): u8 {
        let r = borrow_global<DummyResource>(addr);
        r.val
    }

    public fun remove_dummy(s: signer) {
        let _r = move_from<DummyResource>(signer::address_of(&s));
    }

    public fun test_runner(s: signer): vector<u8> {
        store_dummy(s, 9u8);

        let ast = make_sample_ast();

        let ast_str = ast_to_string(&ast);

        let dummy_val = read_dummy(signer::address_of(&s));

        remove_dummy(s);

        // Compose string like "AST: <ast_str> DummyVal: <dummy_val>"
        let prefix = string::utf8(b"AST: ");
        let suffix1 = string::utf8(b" DummyVal: ");
        let dummy_val_str = digit_to_string(dummy_val);
        let temp1 = string::concat(prefix, ast_str);
        let temp2 = string::concat(temp1, suffix1);
        string::concat(temp2, dummy_val_str)
    }

}

//# run 0xCAFE::AstDebug::test_runner --signers 0xDEAD

// Featurres:
// 028ad224eff2f384fbe0cfff661afd67: Rely on the compiler to infer missing acquire annotations in functions when `acquires` is at least version 2.2.
// 4643c3f27d399e759b2856df09bfb549: Use temporary expressions when you need to store intermediate values during computation.
// 4c1b162e569b5e6adfd7418625892667: Generate a verbose string representation of an Abstract Syntax Tree (AST) node for debugging purposes.
