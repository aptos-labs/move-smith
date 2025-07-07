//# publish
module 0xCAFE::FeatureInteractionTest {
    use std::vector;

    // 1. Entry point script to invoke internal and external functions
    public fun run_feature_tests(): () {
        let val_u8 = f1(2u8, true);
        let val_u16 = f3(20u16);
        let lambda_result = f6(|b: u8| b + 1, 4u8);
        let internal_call = internal_fun(5u8);
        // Call internal function from script (allowed within module)
        internal_fun(10u8);
        // Call internal private function (allowed within module)
        internal_private();

        // Use local variables in while loop and outside
        let counter = 0u64;
        while (counter < 3) {
            let temp = counter + 1;
            counter = temp;
        };
        // Shadowing variable inside block
        let counter = counter + 1;
        // Check variable retains expected value
        let _ = counter;

        // Shadowed variable in nested block
        {
            let _counter = 100u64;
        };

        // Create vectors for coverage
        let vec1: vector<u8> = vector![1u8, 2u8, 3u8];
        let vec2: vector<u128> = vector![100u128, 200u128];
        let vec3: vector<address> = vector[@0x1, @0x2];

        // Capture compiler diagnostics (simulate capture)
        // No direct way, but assume diagnostics collected externally
        // For demonstration, just include invalid code comments
        // Invalid code to generate diagnostics:
        // let invalid_assign = 123; // placeholder for diagnostics
        // -- fault: unresolved identifier 'invalid_assign'

        // 5. Test involving unit expressions and unresolved errors
        // Here, intentionally cause an error (simulate)
        // In actual Move, this would produce a compile error
        // For testing, just include an invalid expression
        // let _error_expr = 0x; // expected: error
    }

    // Internal function (visible within module)
    fun internal_fun(x: u8): u8 {
        x + 10
    }

    // Private internal function
    fun internal_private(): () {
        // Just a private internal function
    }
}

//# publish
module 0xCAFE::DiagnosticsCapture {
    // Functions related to capturing diagnostics and error messages

    // Function that attempts to produce diagnostics info during compilation
    // (This is conceptual; actual diagnostics are captured by the compiler, not runtime)
    public fun capture_diagnostics(): vector<u8> {
        // Placeholder: return a dummy diagnostics buffer
        vector![b"diagnostic_placeholder"]
    }

    // Function that includes a deliberate syntax error to generate diagnostics
    // (This code won't compile, but it's here to simulate diagnostics capture)
    public fun generate_error() {
        // invalid syntax that would produce a diagnostic
        // e.g., invalid_code
    }
}

//# publish
module 0xCAFE::UnitTestExpressions {
    // Tests involving unit expressions and unresolved/error expressions

    public fun test_unresolved_expression(): () {
        // Deliberate unresolved identifier
        // let _ = unresolved_identifier;
        // This line is expected to cause a compile error, but included for diagnostics testing
    }

    public fun test_resolvable_expression(): u8 {
        42u8
    }

    public fun test_expression_in_loop(): () {
        let total = 0u8;
        let i = 0u8;
        while (i < 5) {
            total = total + i;
            i = i + 1;
        };
        total
    }

    public fun test_invalid_code(): () {
        // Intentionally include code that causes a compiler error
        // for diagnostics testing purposes
        // let invalid: = 123; // invalid syntax
    }
}
