//# publish
module 0xCAFE::AstSimplifyFullTest {
    use std::debug;

    /// Recursive function: returns true if x is odd
    public fun odd(x: u64): bool {
        if (x == 0) {
            false
        } else {
            even(x - 1)
        };
    }

    /// Recursive function: returns true if x is even
    public fun even(x: u64): bool {
        if (x == 0) {
            true
        } else {
            odd(x - 1)
        };
    }

    /// Check recursion correctness for odd 5 and even 4
    public fun recursion_check() {
        let is_odd_5 = odd(5);
        let is_even_4 = even(4);
        debug::print(&b"Check odd(5) == true: ");
        debug::print(&if (is_odd_5) { b"true" } else { b"false" });
        debug::print(&b"\n");
        debug::print(&b"Check even(4) == true: ");
        debug::print(&if (is_even_4) { b"true" } else { b"false" });
        debug::print(&b"\n");
        assert!(is_odd_5, 1);
        assert!(is_even_4, 2);
    }

    // A runner function to invoke checks for the active experiment
    public fun run_all() {
        // This simulates the AST_SIMPLIFY_FULL experiment being active
        recursion_check();
    }
}

//# run 0xCAFE::AstSimplifyFullTest::run_all

// Featurres:
// 407795779da1e58cabdb55f16af6ad6b: Enable full AST simplification with code elimination when the 'AST_SIMPLIFY_FULL' experiment is active.
// 10546924630b0d63e2ad2e5573508ba2: Test that the recursive functions `odd` and `even` correctly determine the parity of a number and that `recursion_check` asserts their expected outcomes for input 5 and 4.
// fb32f3b3b1dcf46b73265725e707d593: Specify the address for a Move module, which can be checked for redundancy and correctness.
