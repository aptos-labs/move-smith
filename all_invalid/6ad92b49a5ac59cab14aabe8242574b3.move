//# publish
module 0xCAFE::FieldAccessDemo {
    /// Struct with public fields for field access testing
    struct MyStruct has copy, drop, store {
        pub field1: u64,
        pub field2: bool,
    }

    /// Returns a sample struct populated with values
    public fun make_struct(): MyStruct {
        MyStruct { field1: 42, field2: true }
    }

    /// Demonstrates field access and returns value of field1
    public fun get_field1(): u64 {
        let s = make_struct();
        s.field1
    }

    /// Demonstrates access and mutation of field2
    public fun toggle_field2(): bool {
        let s = make_struct();
        s.field2 = !s.field2;
        s.field2
    }

    /// A runner function to exercise both field gets and field sets
    public fun runner(): u64 {
        let s = make_struct();
        let v = s.field1;
        s.field2 = false;
        if (s.field2) {
            v + 1
        } else {
            v + 2
        }
    }
}
//# run 0xCAFE::FieldAccessDemo::runner

//# publish
module 0xCAFE::ExitAndDiagnosticDemo {
    use std::debug;
    use std::signer;

    /// Function to conditionally emit diagnostic and exit with code 1
    public fun exit_if_true(account: &signer, should_exit: bool) {
        if (should_exit) {
            let msg: vector<u8> = b"Exiting process as should_exit is true!";
            debug::print(&msg);
            // Exit with non-zero code for test. std::error::abort is available in Aptos.
            std::error::abort_code(1);
        };
        ()
    }

    /// Runner for convenient script test
    public fun runner(account: &signer) {
        exit_if_true(account, true);
    }
}
//# run 0xCAFE::ExitAndDiagnosticDemo::runner --signers 0xCAFE

//# run 0xCAFE::ExitAndDiagnosticDemo::exit_if_true --signers 0xCAFE --args false

//# publish
module 0xCAFE::LoggingDemo {
    use std::env;
    use std::debug;

    /// Attempts to get log file name from an environment variable and print it
    public fun setup_logging() {
        let log_env: vector<u8> = b"LOG_FILE";
        // Try to get the file name from environment variable.
        let (found, filename) = env::get_env(log_env);
        if (found) {
            let msg = b"File logging to: ";
            debug::print(&msg);
            debug::print(&filename);
        } else {
            let msg = b"Environment variable LOG_FILE is not set!";
            debug::print(&msg);
        }
        // In a real logger, you'd open filename here for log output.
        ()
    }
}
//# run 0xCAFE::LoggingDemo::setup_logging

//# script
script {
    use 0xCAFE::FieldAccessDemo;

    fun main() {
        let s = FieldAccessDemo::make_struct();
        let _field1 = s.field1;
        let _field2 = s.field2;
        // No assertion needed; this script simply exercises field access.
        ()
    }
}
//# run

//# script
script {
    use 0xCAFE::ExitAndDiagnosticDemo;
    use std::signer;

    fun main(account: signer) {
        // should_exit is false, so process should not abort.
        ExitAndDiagnosticDemo::exit_if_true(&account, false);
    }
}
//# run --signers 0xCAFE

//# script
script {
    use 0xCAFE::LoggingDemo;

    fun main() {
        LoggingDemo::setup_logging();
    }
}
//# run

// Featurres:
// 0262f9a999d19ef8348c84365785f4bf: Access fields of structs using dot notation, such as `my_struct.field`.
// 2d436c6091fcd5bac792d6332a0dc20a: Exit the process with code 1 after displaying diagnostics if 'should_exit' is true.
// 56a82df6b40d543d56a4081aa298c444: Set up file logging by specifying a file name from the environment variable.
