
//# publish
module 0xCAFE::InvariantTest {
    use std::vector;

    struct Counter has store, key {
        count: u64,
    }

    // Define an invariant that enforces counter is always non-negative (u64, so always true, just for test)
    // Note: In Move, invariants are specified as "invariant" blocks within the module.
    // The syntax should be 'invariant <path> { ... }'
    // The path should be an absolute address followed by the resource type.
    // Corrected the syntax from 'invariant [path] { ... }' to 'invariant path { ... }'

    // Correct invariant syntax:
    invariant 0xCAFE::InvariantTest::Counter {
        exists(&Counter {count: x}) {
            x.count >= 0
        }
    }

    // Define a nested attribute (not nested attributes are disallowed) to test attribute nesting enforcement
    // expected_failure(nested_attribute_not_allowed)]
    // nested_attribute]
    fun dummy() {}

    // Function that manipulates vector, purposely causing a vector operation error (out of bounds access)
    public fun faulty_vector_operation(v: vector<u8>, index: u64): u8 {
        // Accessing an invalid index
        vector::borrow(&v, index)
    }

    // Function with attribute indicating expected failure due to vector error
    // expected_failure(vector_error)]
    public fun trigger_vector_error() {
        let vec: vector<u8> = vector::empty();
        // Intentionally cause error: borrow from empty vector at index 0
        faulty_vector_operation(vec, 0)
    }

    // Function to test use of invariant with nested attributes
    public fun increment_counter(c: &mut Counter) {
        // Correct invariant syntax:
        invariant 0xCAFE::InvariantTest::Counter {
            exists(&Counter {count: c.count}) {
                c.count >= 0
            }
        }
        c.count = c.count + 1;
        // No violation here
    }
}



//# run 0xCAFE::InvariantTest::trigger_vector_error

// Featurres:
// 0c4d7dd63c53666492908dbc9dcc5372: Define invariants in your Move code using the 'invariant' keyword for formal verification and specifications.
// 438a5a28c4b3a3d65c2b6eb8f4ca3992: Indicate a vector operation error expected in your test with `// expected_failure(vector_error)]` attribute, with optional minor status code.
// e743770752c5b668ad11d9541647e0f6: Specify whether attributes are nested or non-nested to enforce attribute usage rules.