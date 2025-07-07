//# publish
module 0x1::abort_test_module {
    public fun cause_large_abort(): u64 {
        // Trigger an abort with a large number to test abort behavior
        abort 0xFFFFFFFFFFFFFFFF;
    }

    public fun run_abort(): () {
        cause_large_abort()
    }
}

//# run 0x1::abort_test_module::run_abort
