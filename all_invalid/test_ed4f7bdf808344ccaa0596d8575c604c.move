//# publish
module 0xabcde::nested_abort_test {
    fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    public fun trigger_abort(): u64 {
        abort 42
    }

    public fun run_nested_abort(): u64 {
        // Attempt to call trigger_abort which always aborts
        // Wrap in a try to catch the abort would be ideal, but since this is a test, just call directly
        // The transaction should revert here due to abort
        trigger_abort()
    }

    public fun test_nested_abort(): u64 {
        // Call the function which triggers nested aborts
        // It is expected that calling run_nested_abort will cause the transaction to revert
        run_nested_abort()
        0 // unreachable code if abort occurs
    }
}

//# run 0xabcde::nested_abort_test::test_nested_abort