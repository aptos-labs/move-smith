//# publish
module 0xabcde::conditional_test {
    fun process_value(val: u64, flag: bool) {
        let mut local_var = move val;
        if (flag) {
            // When true, just log the current value
            // Since Move doesn't have native logging, we simulate state change
            // by calling a dummy function or just passing
        } else {
            // When false, reassign the local variable and perform an additional operation
            local_var = local_var + 10;
        }
    }

    fun run_test_cases() {
        // Call process_value with true
        process_value(10, true);
        // Call process_value with false
        process_value(20, false);
    }
}

//# run 0xabcde::conditional_test::run_test_cases

//# publish
module 0xabcde::test_module {
    fun test_conditional_behavior() {
        // Testing different flag inputs and variable reassignment
        process_value(50, true);
        process_value(100, false);
    }

    fun process_value(val: u64, flag: bool) {
        let mut local_var = move val;
        if (flag) {
            // No reassignment, simply proceed
        } else {
            // Reassign local_var
            local_var = local_var + 5;
        }
    }

    public fun run() {
        test_conditional_behavior();
    }
}

//# run 0xabcde::test_module::run --signers 0x1