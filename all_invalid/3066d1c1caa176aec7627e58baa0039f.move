
//# publish
module 0xCAFE::ShortCircuitTest {
    use std::error;

    // Struct definition to test declaration
    struct DummyStruct has copy, drop, store {
        value: u64,
    }

    // Function to simulate error; should only be called if short-circuit doesn't prevent it
    public fun error_fn(): bool {
        error::abort_code(999);
        false // Unreachable, just for completeness
    }

    // Function to test short-circuit OR (||)
    public fun test_or_short_circuit(a: bool, b: bool): bool {
        // If 'a' is true, 'error_fn' should NOT be called
        let result = a || error_fn();
        result
    }

    // Function to test short-circuit AND (&&)
    public fun test_and_short_circuit(a: bool, b: bool): bool {
        // If 'a' is false, 'error_fn' should NOT be called
        let result = a && error_fn();
        result
    }

    // Function to fully evaluate AST for logical expressions
    public fun evaluate_logical_expressions() {
        // These should short-circuit and not call error_fn
        let or_result = test_or_short_circuit(true, false);
        let and_result = test_and_short_circuit(false, true);
        // These should both be true for 'or' and false for 'and'
        assert!(or_result, 0);
        assert!(!and_result, 1);
    }
}