
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Test pragma property for metadata, not typical in Move but simulated via comments
    // pragma: test-feature=type-parameters

    // Define a generic struct with multiple type parameters
    struct MultiTypeStruct<A, B> has copy, drop, store {
        first: A,
        second: B,
    }

    // Function to create and return a generic struct instance
    public fun create_multi_struct<A: copy, B: copy>(a: A, b: B): MultiTypeStruct<A, B> {
        let s = MultiTypeStruct { first: a, second: b };
        s
    }

    // Function to return a tuple containing the struct and a boolean
    public fun consume_token_and_return<A: copy, B: copy>(s: MultiTypeStruct<A, B>, expected_token: u8): (MultiTypeStruct<A, B>, bool) {
        // Using consumes_token to simulate token matching
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

// Featurres:
// afa4237eee3de0f7590f7d3a63c5656f: Annotate spec blocks and members with pragma properties for meta-information or tool directives.
// b89769747726b0ff0a79b7b55c58d5d4: Use type parameters in generic functions and structs.
// bef9dbef17a7b6cdbd55be5addf073bf: Leverage 'consume_token' to ensure that the next token in the token stream matches an expected token, facilitating correct parsing of Move source code.
