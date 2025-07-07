// Transactional test for Move compiler and VM features:
// 1) Diagnostic messages with code snippets as labels
// 2) Struct with a field with explicit type annotation
// 3) Function specifying return type with colon and a single return value

module 0x1::TestTxnFeatures {
    use std::error;
    use std::signer;

    // Struct with explicit field type annotation
    struct ExplicitFieldTypeStruct has copy, drop, store {
        value: u64, // explicit type annotation for field
    }

    // Function with single return value and colon suffix for return type
    // Creates an instance of ExplicitFieldTypeStruct with input and returns u64
    public fun create_and_get_value(addr: &signer, val: u64): u64 {
        let s = ExplicitFieldTypeStruct { value: val };
        // Emit a label in diagnostic by triggering an error with code snippet reference
        assert!(val > 0, error::invalid_argument(0x1, b"value must be > 0"));
        // Return the inner value
        s.value
    }
}

#[test]
fun transactional_test_feature_coverage() {
    // Prepare a signer for the transaction
    let sender = @0x1;
    // Test value to be used
    let test_val: u64 = 42;

    // Call the tested function with valid value
    let result = 0x1::TestTxnFeatures::create_and_get_value(&signer::borrow(&sender), test_val);
    // Assert the returned value matches input
    assert!(result == test_val, 0x1);

    // Test with invalid value (expected to fail)
    let invalid_val: u64 = 0;
    let res = move_to_abort {
        0x1::TestTxnFeatures::create_and_get_value(&signer::borrow(&sender), invalid_val);
    };
    // Check error abort code matches our diagnostic label error
    assert!(error::is_abort_code(res, error::invalid_argument(0x1, b"value must be > 0")), 0x1);
}

// Featurres:
// a3ed19c19dd63b956349eaca76d07950: Include code snippets or identifiers in diagnostic messages as labels.
// c2361614d8d86136ea1e6665a21ea40d: Define a field with an explicit type annotation in a Move struct
// 290d9ace984c73bfe9a12a6153ee5fe7: Specify the return type of a function with a single return value using a colon followed by the signature token.
