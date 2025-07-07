// # publish
module 0xCAFE::SwapTest {
    /// Swaps two u64 values and returns them as a tuple (b, a)
    public fun swap(a: u64, b: u64): (u64, u64) {
        (b, a)
    }

    /// A runner function that calls swap with example values
    public fun runner() {
        let (x, y) = swap(123u64, 456u64);
        // Using the variables so no warnings (no assertions required)
        let _ = x;
        let _ = y;
    }
}
// # run 0xCAFE::SwapTest::runner

// # publish 0x1234
module 0x1234::StringAddrTest {
    /// Just a dummy public function to be able to run
    public fun dummy(): u64 {
        42u64
    }

    public fun runner() {
        let val = dummy();
        let _ = val;
    }
}
// # run 0x1234::StringAddrTest::runner

// # publish
module 0xCAFE::LogicOpsTest {
    /// Function that always fails, used to test short-circuiting
    fun error(): bool {
        abort 0xDEAD;
        // unreachable code
        false
    }

    /// Test that (true || error()) does not call error
    public fun test_or_true_short_circuit() {
        let result = true || error();
        let _ = result;
    }

    /// Test that (false || true) evaluates true correctly without error
    public fun test_or_false_true() {
        let result = false || true;
        let _ = result;
    }

    /// Test that (false || error()) calls error (would abort)
    /// We won't call this function in runner to avoid abort,
    /// but having it defined to test the compilation

    /// Test that (false && error()) calls error (would abort)
    /// Also not called in runner.

    /// Test that (true && error()) does not call error (short-circuit)
    public fun test_and_false_short_circuit() {
        let result = false && error();
        let _ = result;
    }

    /// Test that (true && true) evaluates true
    public fun test_and_true_true() {
        let result = true && true;
        let _ = result;
    }

    /// Runner function to call the safe short-circuit tests only
    public fun runner() {
        test_or_true_short_circuit();
        test_or_false_true();
        test_and_false_short_circuit();
        test_and_true_true();
    }
}
// # run 0xCAFE::LogicOpsTest::runner

// # run
script {
    use 0xCAFE::SwapTest;
    use 0xCAFE::LogicOpsTest;

    fun main() {
        // Directly call swap and unpack tuple
        let (a, b) = SwapTest::swap(10u64, 20u64);
        let _ = a;
        let _ = b;

        // Call LogicOpsTest runner to check logical ops short-circuiting
        LogicOpsTest::runner();
    }
}