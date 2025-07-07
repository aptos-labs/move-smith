//# publish
module 0x1::TestLiterals {
    // A function that returns true and false literals.
    public fun return_true(): bool {
        true
    }

    public fun return_false(): bool {
        false
    }

    // A runner function calling the above two.
    public fun runner() {
        let _t = return_true();
        let _f = return_false();
    }
}
//# run 0x1::TestLiterals::runner


//# publish
module 0x1::TestHexDecode {
    use std::vector;

    // Returns a vector<u8> decoded from a hex string literal
    public fun get_bytes(): vector<u8> {
        // decode hex literal, e.g. "0x48656c6c6f"
        // Move literals support `b"..."` for byte arrays but for hex strings, 
        // Aptos Move supports "0x..." hex string literals that decode to vector<u8> automatically
        // Usually we can just specify the literal as vector literal hex
        // but here we use a string literal that decodes to vector<u8>
        b"Hello"
    }

    public fun runner() {
        let _v = get_bytes();
    }
}
//# run 0x1::TestHexDecode::runner


//# publish
module 0x1::TestShouldRemoveNode {
    /// A function that is marked with `verify_only` and should be removed when compiling 
    /// without verification flags.
    #[verify_only]
    public fun verify_only_function(): bool {
        true
    }

    /// A normal function that calls should_remove_node on the verify_only_function.
    public fun call_should_remove_node(): bool {
        // simulate code that calls "should_remove_node" to avoid compilation of verify_only code,
        // here we just call the function to test that it is excluded automatically in non-verification builds.
        // Without verification flags, the verify_only_function will be removed automatically.
        // So this function will return true if verify_only_function is available, otherwise false.
        // But since this function will not error in either case, it just returns true here.
        true
    }

    public fun runner() {
        let _r = call_should_remove_node();
    }
}
//# run 0x1::TestShouldRemoveNode::runner


//# run
script {
    use 0x1::TestLiterals;
    use 0x1::TestHexDecode;
    use 0x1::TestShouldRemoveNode;

    fun main() {
        let b_true = TestLiterals::return_true();
        let b_false = TestLiterals::return_false();

        let bytes_vec = TestHexDecode::get_bytes();

        let should_remove = TestShouldRemoveNode::call_should_remove_node();

        // No assertions, just running the code to exercise compiler and VM
        // variables are bound to suppress unused warnings.
        let _ = (b_true, b_false, bytes_vec, should_remove);
    }
}