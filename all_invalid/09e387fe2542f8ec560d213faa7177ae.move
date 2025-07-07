//# publish
module 0xA550::TestModule {
    use std::debug;
    use std::drop;
    use std::option::{Self, Option};
    use std::vector;
    use std::bytecode::{Bytecode, dump_names_from_source};

    // Function to test detailed debug logs with bytecode dump from source file name
    public fun debug_log_bytecode_names(source_name: &str) {
        let code = /* assume bytecode or source code is available here */;
        // Enable debug logging
        debug::print(&"Debug: Starting bytecode dump for source: ".to_string() + source_name);
        dump_names_from_source(source_name);
    }

    // Function to interpret a literal address specifier
    public fun interpret_literal_address() {
        let addr: address = (0x1234);
        debug::print(&"Interpreted address: ".to_string() + &address::to_string(&addr));
    }

    // Function to demonstrate Drop ability usage
    public fun test_drop_ability() {
        let value = 42;
        debug::print(&"Before drop: ".to_string() + &value.to_string());
        drop::drop(value); // explicitly discard value
        // no use after drop to confirm explicit discard
    }

    // Function to handle variable bindings in lambda and blocks
    public fun variable_binding_in_lambda() {
        let mut x = 10;
        let lambda = || {
            // 'x' is captured mutably
            x = x + 5;
            debug::print(&"In lambda, x: ".to_string() + &x.to_string());
        };
        lambda();
        debug::print(&"After lambda, x: ".to_string() + &x.to_string());
    }

    // Function with documentation attribute
    /// This function is annotated with a doc comment for metadata.
    public fun documented_function() {
        debug::print(&"This function has documentation metadata");
    }

    // Runner function to execute all tests
    public fun run_all_tests() {
        debug_log_bytecode_names("test_source.move");
        interpret_literal_address();
        test_drop_ability();
        variable_binding_in_lambda();
        documented_function();
    }
}

//# run 0xA550::TestModule::run_all_tests