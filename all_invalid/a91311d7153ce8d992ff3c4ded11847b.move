// The test file to exercise Move compiler and VM:
// - variable live intervals labeled by compiler analysis
// - function declarations ending with semicolon or block
// - diagnostic messages with secondary labels

// We will publish a module with a few functions to test each feature in compilation phase.
// Then run some scripts and internal functions to exercise VM execution.

//# publish
address 0xCAFE {
    module LiveIntervalsAndDiagnostics {
        use std::debug;

        // This struct is just to illustrate key/store capabilities for storage if needed
        struct Dummy has store, key, drop { val: u64 }

        /// Function to test variable live intervals.
        /// The function declares and uses multiple variables, and shadows some variables.
        /// The compiler should correctly mark live intervals accordingly.
        public fun test_live_intervals(): u64 {
            let a = 10u64;
            // start live interval a
            let b = a + 20u64;
            // start live interval b; a is still live
            let a = b * 2u64;
            // a is shadowed, starts a new live interval
            let _c = b + a;
            // c is temporary, only used here
            a + b
            // returns a + b = (b*2) + b = b*3 = (a+20)*3
        }

        // Native function declaration ends with semicolon
        native public fun native_mul(a: u64, b: u64): u64;

        /// A runner function to call test_live_intervals internally
        public fun runner(): u64 {
            test_live_intervals()
        }

        /// Function to simulate diagnostic message:
        /// We emit an error with secondary labels using debug::print for demonstration.
        /// The diagnostic printing is indirect since compiler diagnostics are outside Move language.
        public fun diagnostic_simulation() {
            debug::print(b"Error: Invalid operation\n");
            debug::print(b" --> In function diagnostic_simulation\n");
            debug::print(b"  |\n");
            debug::print(b"3 | let x = 42u64 / 0u64; <- division by zero\n");
            debug::print(b"  |            ^^^^^^^^^ secondary label: divisor cannot be zero\n");
        }
    }
}

//# run 0xCAFE::LiveIntervalsAndDiagnostics::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::LiveIntervalsAndDiagnostics;

    fun main() {
        let res = LiveIntervalsAndDiagnostics::runner();
        LiveIntervalsAndDiagnostics::diagnostic_simulation();
    }
}

// Featurres:
// 5941f05441d687ea5000876615399dcf: Label the beginning and end of variable live intervals to understand variable liveness within a function.
// eccac62b7732d501973093a96d582dae: End function declarations with a semicolon for native functions or a block for implemented functions.
// 0ce2fd243a3c3fe817c4d035fc0f0684: Render diagnostic messages with secondary labels for additional related information.
