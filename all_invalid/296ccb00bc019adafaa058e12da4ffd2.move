//# publish
module 0x1::TestModule {
    // Declare an inline non-native function
    public fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Function to intentionally cause an error by dividing by zero
    public fun division_error(numerator: u64, denominator: u64): u64 {
        // This will cause a runtime division by zero error
        numerator / denominator
    }

    // Function to test token mismatch error
    public fun token_mismatch_test(): bool {
        // Attempt to move a value with incorrect token type
        // This is designed to generate a diagnostic error during compilation
        // For the purpose of the test, we simulate an incorrect token
        // by calling a function expecting a different token type
        let invalid_token_value = 0xdeadbeef;
        // The function expects a different token type, causing an error
        // This is a placeholder comment to indicate the mismatch
        // In actual code, this would be a type mismatch
        return true;
    }

    // Function that is not native but inline
    public fun inline_multiply(a: u64, b: u64): u64 {
        a * b
    }

    // Runner function to test the above functions
    public fun run_all() {
        // Call inline addition
        let sum = inline_add(10, 20);
        // Call inline multiplication
        let product = inline_multiply(5, 6);
        // Call division error function intentionally
        // which should cause an error at runtime
        let _ = division_error(100, 0);
        // Call token mismatch test
        let _ = token_mismatch_test();
    }
}

//# run 0x1::TestModule::run_all

// Featurres:
// 8031f4c64cc258757a85b6555a15b7be: Handle errors by generating a diagnostic if the token does not match
// 7451805a996290cb5c69ad82faa12742: Declare inline functions that are not native functions.
// 20294188ec76665b821ef7c9560d065a: Indicate an arithmetic error expected in your test with `#[expected_failure(arithmetic_error)]` attribute.
