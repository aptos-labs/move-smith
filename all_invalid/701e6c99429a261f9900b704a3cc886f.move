//** MODULE 1: An external utility module with a function to be used via 'use' elsewhere */

//# publish
module 0xCAFE::Utils {
    // A utility function used via `use ... as ...`
    public fun double(x: u64): u64 {
        x * 2
    }
}

//** MODULE 2: The main module that uses `use`, `program`, and exposes a function for testing logic */

//# publish
module 0xCAFE::MainTest {
    use 0xCAFE::Utils;

    // Only called via a runner, not directly by scripts.
    fun complex_loop_internal(): u64 {
        let total = 0u64;
        let i = 0u64;
        while (i < 10) {
            if (i == 2) {
                i = i + 1;
                continue; // skip 2
            };
            if (i == 7) {
                break; // exit loop at 7
            };
            if (i % 2 == 1) {
                // Odd number, add double(i)
                total = total + Utils::double(i);
            } else {
                // Even number, add i
                total = total + i;
            };
            i = i + 1;
        };
        total
    }

    /// Test the Move program function simplicity for filtering
    /// This is here to exercise the `program` feature; it's a stub for test infra.
    public fun program(): bool {
        // Typically of the form `move_prover/program filter` 
        // For the test, we just return true
        true
    }

    // Runner for testing complex_loop_internal
    public entry fun runner() {
        let result = Self::complex_loop_internal();
        // Result is available for debugger or inspection
        // (No assertion required by prompt)
        result;
    }
}

//# run 0xCAFE::MainTest::runner --signers 0xCAFE

//** SCRIPT: Calls the utility function via `use` in script form */

//# run
script {
    use 0xCAFE::Utils;

    fun main(account: &signer) {
        let x = 21u64;
        let y = Utils::double(x);
        // y is 42, testing 'use' in a script
        // (No assertion needed)
        y;
    }
}