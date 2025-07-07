//# publish
module 0x1::TestModule {
    use std::debug;
    use std::vector;

    // Top-level spec block as a function
    public fun top_level_spec() {
        // Spec for a function accepting a literal address
        spec {
            address_literal: (0x1234);
        }
    }

    // Spec block with detailed invariant annotation
    public fun invariant_example() {
        // Declare an invariant with property and expression
        spec {
            invariant property: "balance_non_negative" {
                balance >= 0;
            }
        }
        // Example data or operations (not actually executable here)
    }

    // Module with an explicit debug log
    public fun log_debug_example() {
        debug::print("[DEBUG] Starting debug log for Move source file 'test.move'");
        // Some operations here
    }

    // Spec with parsing expressions starting at certain keywords
    public fun parse_keywords() {
        // Using 'abort' as expression start
        abort;
        // Using 'break'
        break;
        // Using 'continue'
        continue;
        // Using 'if'
        if (true) {
            // do something
        }
        // Using 'loop'
        loop {
            // do something
        }
        // Using 'return'
        return;
        // Using 'while'
        while (true) {
            // do something
        }
    }

    // Function with a loop that has an unconditional return inside
    public fun loop_with_unconditional_return() {
        let mut i = 0;
        while (i < 10) {
            // Unconditional return inside the loop
            return;
            // This code should be skipped
            i = i + 1;
        }
        // Additional code that should not be executed due to the return
        debug::print("[DEBUG] This line should not execute");
    }

    // Run the function with an unconditional return to ensure proper exit
    //# run 0x1::TestModule::loop_with_unconditional_return
    public fun run_loop_with_unconditional_return() {
        Self::loop_with_unconditional_return();
    }
}