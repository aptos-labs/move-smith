//# publish
module 0xDEADBEEF::EscapeSequences {
    /// Function to test parsing of escape sequences in byte string literals
    public fun parse_escape_sequences(): vector<u8> {
        // Byte string with various escape sequences
        let seq1 = b"\x41\x42\x43"; // ABC
        let seq2 = b"\n\r\t\\\'\""; // newline, carriage return, tab, backslash, single quote, double quote
        let seq3 = b"\x00\xFF"; // null byte and 255
        let mut result = vector::empty<u8>();
        vector::append(&mut result, &seq1);
        vector::append(&mut result, &seq2);
        vector::append(&mut result, &seq3);
        result
    }

    /// Function to create a module with explicit dependencies (simulate)
    public fun create_module_with_deps(): bool {
        // In Move, dependencies are declared at the module level via `use` declarations.
        // This function is a placeholder to simulate dependency declaration.
        true
    }

    /// Function that returns the address of the module (for testing module address references)
    public fun get_module_address(): address {
        @0xDEADBEEF
    }

    /// Runner to invoke parse_escape_sequences
    public fun run_parse_escape_sequences(): vector<u8> {
        parse_escape_sequences()
    }
}

//# publish
module 0xFEEDBEEF::InvocationTests {
    use 0xDEADBEEF::EscapeSequences;

    /// A dummy function to demonstrate assigning to a variable, invoking directly, and via lambda
    public fun test_invoke_variants() {
        // Import the module functions
        let module_addr = EscapeSequences::get_module_address();

        // Assign function to a variable
        let func_var = EscapeSequences::parse_escape_sequences;

        // Direct invocation
        let result_direct = EscapeSequences::parse_escape_sequences();

        // Via stored variable
        let result_var = func_var();

        // Using a lambda (closure)
        let lambda = || EscapeSequences::parse_escape_sequences();
        let result_lambda = lambda();

        // Normally, assertions would go here, but we ignore them as per instructions
    }

    /// Runner to run the invocation test
    //# run 0xFEEDBEEF::InvocationTests::test_invoke_variants
}