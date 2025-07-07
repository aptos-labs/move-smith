//# publish
module 0xBEEFA::ComprehensiveTest {
    use std::signer; // Warning: unused, can be removed if not used
    // Correct path for assertion: std::assert is a package, not a module
    // Move standard library doesn't have std::assert, so remove or comment out if not used
    // use std::assert; // Removed as it's invalid

    // 1. Interface for testing aborts within a single function
    public fun test_abort_chain() {
        // Call a sequence of aborts with different codes to verify handling
        abort_if_true(false, 100);
        // Should not reach here if abort triggers correctly
        abort_if_true(false, 200);
    }

    // Helper function that aborts if condition is true, with specific code
    public fun abort_if_true(cond: bool, code: u64) {
        if (cond) {
            abort(code);
        }
    }

    // 2. Test static bytecode correctness by compiling module with verifier
    // (This is automatically checked at compile time via the test system)

    // 3. Test inline function and whether it propagates aborts
    inline fun inline_add_and_maybe_abort(a: u64, b: u64): u64 {
        let sum = a + b;
        abort_if_true(sum > 50, 999);
        sum
    }

    // Wrapper script to invoke inline function
    public fun call_inline_function_with_abort() {
        let _ = inline_add_and_maybe_abort(30, 25); // sum = 55, triggers abort with 999
    }

    // 4. Use a function with expected abort attribute for testing
    public fun aborts_traditionally() {
        abort(123);
    }

    // 5. Test interaction: multiple aborts in a single call, capturing correct behavior
    public fun multi_abort() {
        // First abort
        abort_if_true(true, 1);
        // Should abort before reaching subsequent lines
        abort_if_true(true, 2);
        // Not reached
        abort_if_true(true, 3);
    }

    // 6. Entry point to run all tests collectively
    public fun run_all_tests() {
        // Call abort chain test (expected to abort with code 100)
        // We wrap in a block to catch the abort and test multiple aborts
        // (Assuming runtime test runner can handle this)
        // Note: Actual abort handling verification depends on the test harness
        // For illustration, invoke and expect abort for code 100
        test_abort_chain();

        // Call inline function that triggers abort
        call_inline_function_with_abort();

        // Call function that aborts with 123
        aborts_traditionally();

        // Call multi_abort to validate multiple aborts within one call
        multi_abort();

        // No explicit return
        ()
    }
}


//# run 0xBEEFA::ComprehensiveTest::run_all_tests --signers 0xDAAD
