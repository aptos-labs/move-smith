//# publish
module 0x42::VectorTests {
    struct DummyStruct {
        value: u64,
    }

    public fun create_and_return_empty_struct_vector(): vector<DummyStruct> {
        vector[]
    }

    public fun create_and_return_empty_signer_vector(): vector<signer> {
        vector[]
    }

    public fun create_and_return_empty_generic_vector<T>(): vector<T> {
        vector[]
    }

    public fun create_and_return_nested_struct_vector(): vector<vector<DummyStruct>> {
        vector[]
    }

    public fun create_and_return_nested_signer_vector(): vector<vector<signer>> {
        vector[]
    }

    public fun create_and_return_nested_generic_vector<T>(): vector<vector<T>> {
        vector[]
    }

    /// A function that runs the above functions with specific type parameters
    public fun run_all(): () {
        // Create and return empty vector of DummyStruct
        let _ = create_and_return_empty_struct_vector();
        // Create and return empty vector of signer
        let _ = create_and_return_empty_signer_vector();
        // Create and return empty vector of a generic type (e.g., u8)
        let _ = create_and_return_empty_generic_vector<u8>();
        // Create and return nested vector of DummyStruct
        let _ = create_and_return_nested_struct_vector();
        // Create and return nested vector of signer
        let _ = create_and_return_nested_signer_vector();
        // Create and return nested vector of generic type (e.g., bool)
        let _ = create_and_return_nested_generic_vector<bool>();
    }
}

//# run 0x42::VectorTests::run_all