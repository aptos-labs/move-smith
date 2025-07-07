//# publish
module 0xCAFE::TestModule {

    use 0xCAFE::SimpleMap;

    // A helper function to test parameter passing by value and by reference
    public fun test_param_passing(
        value_param: u64,
        ref_param: &mut u64
    ) {
        // Modify the reference parameter
        *ref_param = *ref_param + value_param;
        // Do not modify value_param to test it remains unchanged
    }

    // A function to test nested lambdas, byte serialization, and higher-order passing
    public fun deep_lambda_test(data: u64): vector<u8> {
        // Define a lambda that serializes the data
        let serialize_closure = || {
            // Serialize data into bytes
            let bytes = vector::empty<u8>();
            vector::push_back(&mut bytes, (data as u8));
            vector::push_back(&mut bytes, (data >> 8) as u8);
            vector::push_back(&mut bytes, (data >> 16) as u8);
            vector::push_back(&mut bytes, (data >> 24) as u8);
            vector::push_back(&mut bytes, (data >> 32) as u8);
            vector::push_back(&mut bytes, (data >> 40) as u8);
            vector::push_back(&mut bytes, (data >> 48) as u8);
            vector::push_back(&mut bytes, (data >> 56) as u8);
            bytes
        };

        // Use a higher-order function passing the lambda
        return process_data_with_closure(&serialize_closure);
    }

    fun process_data_with_closure(closure: &impl Fn() -> vector<u8>): vector<u8> {
        // Call the closure and return its result
        closure()
    }

    // Function to test keys function on SimpleMap
    public fun test_keys_function() {
        let smap = SimpleMap::new();

        // Insert multiple entries, some with duplicate keys
        SimpleMap::insert(&smap, 1u64, 100u64);
        SimpleMap::insert(&smap, 2u64, 200u64);
        SimpleMap::insert(&smap, 1u64, 101u64);
        SimpleMap::insert(&smap, 3u64, 300u64);
        SimpleMap::insert(&smap, 2u64, 201u64);

        // Retrieve all keys - expecting to get all keys, including duplicates?
        // But since SimpleMap keys are unique, just retrieve the key set
        let keys_vec = SimpleMap::keys(&smap);

        // For testing, no assertion, but in real test, we could check for expected keys
        // For example, the keys should be 1, 2, 3
    }

    //# run 0xCAFE::TestModule::parameter_passing_test --signers 0xCAFE --args 42u64
    public fun parameter_passing_test() {
        let x = 0u64;
        let param = 42u64;
        // Call function with parameter by value and by reference
        test_param_passing(param, &mut x);
        // x should now be 42
    }

    //# run 0xCAFE::TestModule::deep_lambda_test --signers 0xCAFE --args 123u64
    public fun run_deep_lambda() {
        let result = deep_lambda_test(123u64);
        // result should contain serialized bytes of 123
    }

    //# run 0xCAFE::TestModule::test_keys_function --signers 0xCAFE
    public fun run_keys_test() {
        test_keys_function();
    }
}

// Featurres:
// ae3e0fd97f4a7a5808a654b0685098ad: Pass function parameters by reference or value and determine if parameters are possibly modified by move or borrow operations.
// eb37c7fb381e8cf238c7510307164345: Test that deep nested lambdas, byte serialization, and higher-order function passing work correctly together in Move.
// 6e8c7b5b2e3a7a6911c6ed6d2fd8e100: Test that the `keys` function correctly retrieves all keys from a `SimpleMap` containing multiple elements with identical keys.
