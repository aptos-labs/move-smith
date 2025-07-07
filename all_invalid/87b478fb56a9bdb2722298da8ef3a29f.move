
//# publish
module 0xCAFE::DebugAndPragmaTest {
    /// A simple struct to test storage and borrowing
    struct DebugRes has key, store {
        val: u64,
    }

    /// Publish a resource with given value under the signer's account
    public fun store_resource(s: &signer, v: u64) {
        move_to<DebugRes>(s, DebugRes { val: v });
    }

    /// Borrow the resource immutably and return its value
    public fun borrow_resource_value(addr: address): u64 acquires DebugRes {
        let res_ref: &DebugRes = borrow_global<DebugRes>(addr);
        res_ref.val
    }

    /// A function with pragmas, including no_reentry and no_parallel for compilation/runtime hints
    // pragma(no_reentry)]
    // pragma(no_parallel)]
    public fun pragma_function() {
        // intentionally empty, just to test pragmas parsing and support
    }

    /// A runner function without args that calls pragma_function()
    public fun runner() {
        pragma_function();
    }
}



//# run 0xCAFE::DebugAndPragmaTest::store_resource --signers 0xBEEF --args 123u64



//# run 0xCAFE::DebugAndPragmaTest::borrow_resource_value --args 0xBEEF



//# run 0xCAFE::DebugAndPragmaTest::runner


// Features:
// 33a0e94ea63008c770c66e673cd53379: Enable debugging mode for the Move compiler by setting the 'MOVE_COMPILER_DEBUG' or 'MVC_DEBUG' environment variable.
// 27a4523cbd476b887f836c87951c3546: Test that a resource can be stored in an account, borrowed immutably, and its field value is correctly accessible.
// f94576fe76fd284416a605c3e0607384: Add pragmas to guide verification or compilation.
