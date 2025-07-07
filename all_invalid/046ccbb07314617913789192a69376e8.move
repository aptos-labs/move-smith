//# publish
module 0xCAFE::TestModule {
    use std::debug;

    #[verify_only]
    fun verify_only_func() {
        // This function should only exist during verification
        debug::print(b"verify_only_func called\n");
    }

    // A function to test a Move variable and ensure 'move' works
    public fun test_move_expr() {
        // Create a mutable vector of u8
        let v = b"hello";

        // Use move to create a new variable by moving v (v no longer valid after this)
        let moved_v = move v;

        debug::print(b"test_move_expr: moved_v = ");
        debug::print(&moved_v);
        debug::print(b"\n");
    }

    // Runner function to allow multiple invocations
    public fun runner() {
        // Call test_move_expr multiple times to check logging and move usage
        Self::test_move_expr();
        Self::test_move_expr();
        Self::test_move_expr();
    }
}
//# run 0xCAFE::TestModule::runner --signers 0xCAFE

// Featurres:
// 7b7ba6b96b5e19ebb31f608919ca77b2: Use 'move' to create a move expression for a variable.
// 737856b5e405835319fb4a3052281bdf: Invoke the function multiple times to ensure logging is configured without errors.
// 052d6c58c202ddaf474ff0df4649731a: Use the 'verify_only' attribute to mark code that should only be included during verification and not in production execution.
