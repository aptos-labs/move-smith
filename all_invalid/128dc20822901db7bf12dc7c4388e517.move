
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


//# run 0xCAFE::ShortCircuitTest::evaluate_logical_expressions


// Featurres:
// 3ead418b1ce59f603f43e76987f39c53: Declare structs within modules.
// 83f1d483e2b2f7e354ad08434163cb58: This code tests the short-circuit behavior of logical OR (||) and AND (&&) operators, ensuring that the error function is not called when the left operand determines the result.
// b39b2c5ecfe520bd28e7d0729b418906: Enable full AST (Abstract Syntax Tree) simplification and code elimination for Move programs.
