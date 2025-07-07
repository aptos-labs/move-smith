//# publish
module 0xA550C18::DiagnosticExample {
    use std::signer;
    use std::debug;
    use std::vector;

    /// This function contains code that triggers a diagnostic related to
    /// ambiguity before the '<' operator. In Move diagnostics, we might
    /// suggest to insert a blank space before the '<' to make it less ambiguous.
    public fun ambiguous_operator_example() {
        let x = 5u8;
        let y = 10u8;
        // Intentionally ambiguous without space before '<'
        // For example: (1<2) might be read confusion.
        if (x<y) {
            debug::print(&vector::empty<u8>());
        }
    }

    /// This function demonstrates a loop with an invariant.
    /// We loop from 0 to n-1, and invariant: idx < n holds on each iteration.
    public fun loop_with_invariant(n: u64) {
        let mut idx = 0;
        while (idx < n) 
            invariant {
                // idx is always less than or equal to n
                idx <= n;
            }
        {
            // Just dummy operation
            let _ = idx * 2;
            idx = idx + 1;
        }
    }

    /// This function will run a loop that runs out of gas.
    #[expected_failure(out_of_gas)]
    public fun loop_out_of_gas() {
        let mut i = 0;
        // An infinite loop to exhaust gas: no loop invariants here as it never exits
        while (true) {
            i = i + 1;
        }
    }

    /// Runner function to trigger all tests except the out_of_gas one:
    public fun runner() {
        ambiguous_operator_example();
        loop_with_invariant(5);
    }
}
//# run 0xA550C18::DiagnosticExample::runner --signers 0xA550C18
//# run 0xA550C18::DiagnosticExample::loop_out_of_gas --signers 0xA550C18

//# run
script {
    use 0xA550C18::DiagnosticExample;

    fun main(account: signer) {
        // Call runner to hit ambiguous operator and loop invariant tests
        DiagnosticExample::runner();

        // We also run directly the infinite loop for out_of_gas diagnostic
        // This will fail with expected out of gas error.
        // This is called directly here to exercise VM out of gas detection.
        // Note: in a real scenario this might stall forever, but here for test we expect fail.
        // Uncomment if actually forcing out_of_gas during script execution is allowed:
        // DiagnosticExample::loop_out_of_gas();
    }
}