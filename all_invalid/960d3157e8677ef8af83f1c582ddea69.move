module 0xCAFE::TestModule {
    // Removed unused alias to std::vector
    // use std::vector;

    // Test pragma property for metadata, not typical in Move but simulated via comments
    // pragma: test-feature=type-parameters

    // Define a generic struct with multiple type parameters
    struct MultiTypeStruct<A, B> has copy, drop, store {
        first: A,
        second: B,
    }

    // Function to create and return a generic struct instance
    public fun create_multi_struct<A: copy, B: copy>(a: A, b: B): MultiTypeStruct<A, B> {
        // Use move semantics directly in struct initialization
        MultiTypeStruct { first: a, second: b }
    }

    // Function to simulate token consumption, replace with appropriate implementation
    // Since 'consume_token' is not a standard Move function, we need to define a dummy
    // Alternatively, if the function is part of an external library, ensure it's correctly imported
    // For compilation, we suppose it's a placeholder here
    fun consume_token(token: u8) {
        // Placeholder function - in real test, replace with actual token logic if available
        // For now, do nothing
    }

    // Function to return a tuple containing the struct and a boolean
    public fun consume_token_and_return<A: copy, B: copy>(s: MultiTypeStruct<A, B>, expected_token: u8): (MultiTypeStruct<A, B>, bool) {
        // Call the dummy consume_token function to simulate token matching
        consume_token(expected_token);
        (s, true)
    }

    // Function with type parameter and uses consuming token function
    public fun run_test_with_token() {
        let s = create_multi_struct(42u64, b"hello");
        let (s2, matched) = consume_token_and_return(s, 99u8);
        // no assertions, just for compilation and VM execution
        let _ = s2;
        let _ = matched;
    }
}


//# run 0xCAFE::TestModule::run_test_with_token