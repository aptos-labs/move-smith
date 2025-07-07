
//# publish
module 0xDEA1::DiagnosticTest {
    use std::debug;
    use std::vector;

    // Function to demonstrate providing call site info with custom messages
    public fun report_diagnostic_message(msg: vector<u8>) {
        debug::print(&msg);
    }

    // Function to perform some operations, raise diagnostics with messages
    public fun perform_diagnostics() {
        // Using label 'start
        debug::print(&b"Start of diagnostics\n");
        
        // Call report_diagnostic_message with specific message
        let message1 = b"Diagnostic: Reached phase 1" as vector<u8>;
        report_diagnostic_message(message1);
        // Label 'phase1
        debug::print(&b"Completed phase 1\n");

        // Use label 'then_branch
        let condition = true;
        if (condition) {
            // Use label 'inside_if
            debug::print(&b"Inside if branch\n");
        } else {
            // Use label 'inside_else
            debug::print(&b"Inside else branch\n");
        };

        // Use a loop with label 'loop_label
        let counter: u64 = 0u64; // Make counter mutable
        while (counter < 3u64) {
            debug::print(&b"Loop iteration\n");
            // Use label 'loop_body
            counter = counter + 1u64;
        };

        // Function call with diagnostics
        let result = Self::nested_diagnostics(42u8);

        // Final message with cause explanation
        let cause_msg = b"Diagnostic cause explanation: test completed" as vector<u8>;
        report_diagnostic_message(cause_msg);
    }

    // Helper private function that calls report_diagnostic_message with nested call site info
    fun nested_diagnostics(x: u8): u8 {
        let nested_msg = b"Nested call site report" as vector<u8>;
        report_diagnostic_message(nested_msg);
        // Some computation
        x + 1u8
    }

    // Function to demonstrate label usage with integers
    public fun label_demo() {
        // Correct label syntax using the quote syntax
        'label_start;
        debug::print(&b"Label start\n");
        let value1 = 100u8;
        'label_middle;
        debug::print(&b"Label middle\n");
        let value2 = 200u16;
        'label_end;
        debug::print(&b"Label end\n");
    }
}


//# run 0xDEA1::DiagnosticTest::perform_diagnostics --signers 0xCAFE

//# run 0xDEA1::DiagnosticTest::label_demo --signers 0xCAFE
