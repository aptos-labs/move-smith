
//# expected_failure(major_status_code(1001, 0))
 
//# run
script {
    // Test concurrent immutable references
    let x = 42u64;
    let ref1 = &x;
    let ref2 = &x;
    assert!(*ref1 == 42, 1001);
    assert!(*ref2 == 42, 1001);

    // Deeply nested lambdas and higher-order function passing
    // Define an inner lambda
    let inner_lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
        (a + b, a * b)
    };

    // Outer lambda that takes the inner lambda
    let outer_lambda: || (u8, u8) has copy + drop = || {
        let res = inner_lambda(3u8, 4u8);
        res
    };

    // Call the outer lambda
    let (sum, product) = outer_lambda();
    assert!(sum == 7, 1001);
    assert!(product == 12, 1001);

    // Byte serialization: serialize a u64 and deserialize to verify
    let number: u64 = 0xDEADBEEFCAFEBABEu64;
    let byte_array: vector<u8> = b"SerializationTest";
    // simulate serialization: for test, just cast u64 to bytes
    let serialized: vector<u8> = vector::clone(&vector::from_bytes(&number));
    // simulate deserialization: reconstruct u64
    let deserialized: u64 = *vector::borrow(&vector::from_bytes(&serialized), 0);
    assert!(deserialized == number, 1001);

    // Higher-order function passing: pass a lambda as an argument
    fun apply_lambda<F: copy + drop + |u8| -> u8>(func: F, val: u8): u8 {
        func(val)
    }
    let lambda_fn: |u8| u8 = |a: u8| a + 1;
    let result = apply_lambda(lambda_fn, 5u8);
    assert!(result == 6, 1001);
}


// Featurres:
// e3177c9c5c4c2af6b70738a89240bfb7: Specify a major status code that your test is expected to produce using `#[expected_failure(major_status_code(...))]` attribute, with optional minor status code.
// 2a6560340db2c44d1961e9f7621b8198: Test that multiple immutable references to the same local variable can coexist and be used correctly in expressions and assertions.
// eb37c7fb381e8cf238c7510307164345: Test that deep nested lambdas, byte serialization, and higher-order function passing work correctly together in Move.
