
//# publish
module 0xBADD::LoopTerminationTest {
    use std::debug;
    use std::error;

    // Custom error code for diagnostics
    const ERROR_TERMINATION: u64 = 1001;

    // Function to trigger a loop that terminates via break in an if-else with invariant in a spec block
    public fun run_loop_with_break(flag: bool): u64 {
        let counter = 0u64;

        while (true) 
            invariant (counter <= 10) {  // Loop invariant with only invariant condition
        {
            // Use if-else to decide whether to break the loop
            if (flag) 
                // When flag is true, break out of the loop
            {
                break;
            } 
            else 
                // When flag is false, increment counter
            {
                // purposely cause an error if counter exceeds 10 (should not happen due to invariant)
                if (counter >= 10) 
                {
                    // report diagnostics
                    debug::print(b"Error: counter exceeded 10 before break");
                    error::abort_code(ERROR_TERMINATION);
                } else 
                {
                    counter = counter + 1;
                };
            };
        };
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


//# run 0xBADD::LoopTerminationTest::test_success


// Featurres:
// 77353cca0d584cc0d4fa4bec0fc8bf01: This script tests that a loop correctly terminates when the break statement is executed within an if-else structure involving a boolean condition.
// c9132e0a56364340f2fde78e0448979f: Ensure only 'invariant' conditions are present in a spec block used as a loop invariant
// d0b1590093892fcbd530e24213ca133e: Handle diagnostic errors with a custom error reporting mechanism
