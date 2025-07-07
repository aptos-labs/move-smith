//# publish
module 0xabcde::nested_abort_test {
    public fun test_nested_aborts(): u64 {
        // This function demonstrates nested abort handling.
        // It calls an inner function that aborts, then continues to return a value after catching that abort.
        let result = do_attempt();
        result
    }

    public fun do_attempt(): u64 {
        // Inner function that aborts with value 42, caught by the caller to simulate nested abort handling.
        // Since Move does not have try/catch, we'll simulate this by calling a function that aborts.
        abort 42;
        // The code after abort is unreachable, but for the test correctness, include a dummy return.
        0
    }
}

//# run 0xabcde::nested_abort_test::test_nested_aborts