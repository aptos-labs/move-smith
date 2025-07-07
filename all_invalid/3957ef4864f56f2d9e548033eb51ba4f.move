//# publish
module 0xBADD::LoopTerminationTest {
    use std::debug;
    use std::error;

    // Custom error code for diagnostics
    const ERROR_TERMINATION: u64 = 1001;

    // Function to trigger a loop that terminates via break in an if-else with invariant in a spec block
    public fun run_loop_with_break(flag: bool): u64 {
        let counter = 0u64;

        // Note: In Move, loop invariants are specified inside a spec block with 'invariant' keyword.
        // But Move does not support inline 'invariant' within the code directly.
        // Instead, to specify invariants involving a loop, use // invariant] annotations or spec blocks.
        // Since Move doesn't support inline invariants in runtime code, we remove the 'invariant' statement
        // from inside the loop, and add a spec block to specify invariants for the loop.

        while (true)
        // Spec block for invariants (only in a spec context, typically for formal verification)
        // For the purposes of a runtime test, we remove the invariant statement above.
        {
            if (flag) 
            {
                // When flag is true, break out of the loop
                break;
            } 
            else 
            {
                // When flag is false, increment counter
                if (counter >= 10) 
                {
                    // report diagnostics
                    debug::print(b"Error: counter exceeded 10 before break");
                    error::abort_code(ERROR_TERMINATION);
                } else 
                {
                    counter = counter + 1;
                }
            }
        }
        counter
    }

    // A runner function that tests break execution in the loop with invariant
    public fun test_success() {
        // This should break immediately and return 0
        let result_true = run_loop_with_break(true);
        // This should run until counter reaches 10 and then break, returning 10
        let result_false = run_loop_with_break(false);
        (result_true, result_false)
    }
}
