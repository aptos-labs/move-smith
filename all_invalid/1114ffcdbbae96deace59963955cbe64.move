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


//# expected_failure(major_status_code(1001))
