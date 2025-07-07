// # publish
module 0xCAFE::AccessWarningTest {
    use std::signer;

    /// Internal function that issues an access warning.
    fun access_warning() {
        // Here we simulate an access warning using debug printing since
        // Move doesn't have direct warning constructs.
        // In a real environment, this could map to `Self::warn` or a special intrinsic.
        debug::print(b"Warning: Access outside defining module");
    }

    /// Public function that should not issue warnings when called inside the module.
    public fun internal_function() {
        // Normal internal operation - no warning
        debug::print(b"internal_function executed");
    }

    /// Public function that calls access_warning to simulate warning.
    public fun external_call_warning() {
        access_warning();
    }

    /// Public runner function for testing internal calls - no warning expected.
    public fun runner_no_warning() {
        internal_function();
    }

    /// Public runner function to explicitly call the warning function.
    public fun runner_warning() {
        access_warning();
    }

    /// A function illustrating explicit basic blocks using control flow.
    public fun control_flow_example(x: u64) {
        let result: u64;
        // block 1
        if (x == 0) {
            // block 2
            debug::print(b"Block 2: x == 0");
            result = 0;
        } else if (x < 10) {
            // block 3
            debug::print(b"Block 3: 0 < x < 10");
            result = x * 2;
        } else {
            // block 4
            debug::print(b"Block 4: x >= 10");
            result = x / 2;
        }
        // block 5
        debug::print(b"Result computed");
        // Result is unused as we ignore assertions
        let _ = result;
    }

    /// Test plan function to call other tests in sequence.
    public fun test_plan() {
        runner_no_warning();
        runner_warning();
        control_flow_example(0);
        control_flow_example(5);
        control_flow_example(20);
    }
}
// # run 0xCAFE::AccessWarningTest::runner_no_warning --signers 0xCAFE
// # run 0xCAFE::AccessWarningTest::runner_warning --signers 0xCAFE
// # run 0xCAFE::AccessWarningTest::control_flow_example --signers 0xCAFE --args 0u64
// # run 0xCAFE::AccessWarningTest::control_flow_example --signers 0xCAFE --args 5u64
// # run 0xCAFE::AccessWarningTest::control_flow_example --signers 0xCAFE --args 20u64
// # run 0xCAFE::AccessWarningTest::test_plan --signers 0xCAFE

// # run
script {
    use std::signer;
    use 0xCAFE::AccessWarningTest;

    fun main(account: signer) {
        // Directly invoke module test_plan function
        AccessWarningTest::test_plan();
    }
}

// Featurres:
// 43025b6126a497c589dc9cf1c4ac9828: Use the `access_warning` function to issue warnings when some actions are attempted outside of their defining module.
// 68914556f4c8cfe84aa2f4d67fb0e28a: Design Move code with explicit basic blocks that are connected by control flow edges representing possible executions
// 324fb212eadc0a8bba9ecc14a09b64a1: Collect and organize test functions into a test plan for the module.
