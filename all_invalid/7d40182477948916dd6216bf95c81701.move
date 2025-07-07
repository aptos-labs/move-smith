//# publish
module 0xCAFE::TestVectorsAndClosures {
    use std::vector;
    use std::string;

    // Create vectors of different types
    public fun create_vectors(): (vector<u8>, vector<u64>, vector<bool>, vector<vector<u8>>) {
        let v_u8 = vector[1u8, 2u8, 3u8];
        let v_u64 = vector[10u64, 20u64];
        let v_bool = vector[true, false, true];

        // Nested vector<u8>
        let inner_vec1 = vector[4u8, 5u8];
        let inner_vec2 = vector[6u8];
        let v_vec_u8 = vector[inner_vec1, inner_vec2];

        (v_u8, v_u64, v_bool, v_vec_u8)
    }

    // Nested closures with explicit return types and destructuring
    // Outer closure returns inner closure, which returns a tuple
    // This tests closure creation, returning, calling, and tuple destructuring
    public fun nested_closures_example(x: u8): (u8, u8) {
        let outer: |u8| (|u8| (u8, u8)) has copy+drop = |a: u8| {
            let inner: |u8| (u8, u8) has copy+drop = |b: u8| {
                let sum: u8 = a + b;
                let product: u8 = a * b;
                (sum, product)
            };
            inner
        };
        let inner_closure = outer(x);
        let (sum_result, product_result) = inner_closure(5u8);
        (sum_result, product_result)
    }

    // Verify that the current token string equals an expected string
    // For testing, it compares the passed string with expected string "TOKEN"
    public fun verify_token(token: vector<u8>): bool {
        let expected = b"TOKEN";
        if (vector::length(&token) != vector::length(&expected)) {
            false
        } else {
            let len = vector::length(&expected);
            let mut i = 0u64;
            let mut all_match = true;
            while (i < len) {
                if (*vector::borrow(&token, i) != *vector::borrow(&expected, i)) {
                    all_match = false;
                    break;
                };
                i = i + 1;
            };
            all_match
        }
    }

    // Runner function with no arguments that calls above and uses them
    public fun runner() {
        let (_v1, _v2, _v3, _v4) = create_vectors();
        let (_sum, _prod) = nested_closures_example(7u8);
        let token_vec = b"TOKEN";
        let _is_token = verify_token(token_vec);
    }
}

//# run 0xCAFE::TestVectorsAndClosures::create_vectors

//# run 0xCAFE::TestVectorsAndClosures::nested_closures_example --args 4u8

//# run 0xCAFE::TestVectorsAndClosures::verify_token --args x"544F4B454E"  // "TOKEN" in hex

//# run 0xCAFE::TestVectorsAndClosures::verify_token --args x"544F4B45"   // Partial "TOKE"

//# run 0xCAFE::TestVectorsAndClosures::runner

// Featurres:
// 1db43b384e7751f49e2af7861fc68ee5: Create vectors of types in Move code.
// e9e917f56944b7bf481e4622090aa4b1: Test that nested closures with explicit return types in Move can be created, returned, called, and destructured correctly.
// c5ccc412a1ea336b99a80efac5205dfb: Use this function to verify that the current token is an identifier with a specific expected value.
