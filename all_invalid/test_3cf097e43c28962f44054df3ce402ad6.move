//# publish
module 0xabcde::deep_lambda_test {
    use std::bcs;

    // This function creates deeply nested lambdas, serializes them, and compares their serialization.
    public fun test_nested_lambdas(): bool {
        // Outer lambda, which returns an inner lambda
        let outer_lambda = || {
            // Inner lambda
            || {
                // Innermost lambda
                || {
                    42
                }
            }
        };

        // Serialize the outer lambda
        let outer_bytes = bcs::to_bytes(&outer_lambda);
        // Create another lambda with the same structure
        let another_lambda = || {
            || {
                ||
                42
            }
        };
        let inner_bytes = bcs::to_bytes(&another_lambda);

        // Check if the serialized bytes match
        outer_bytes == inner_bytes
    }
}

///# run 0xabcde::deep_lambda_test::test_nested_lambdas

//# publish
module 0xabcde::byte_serialization_hof {
    use std::bcs;

    // Higher-order function that takes a function and applies it to a fixed value, then serializes result
    public fun apply_and_serialize<F: copy + drop + store>(f: F): vector<u8> {
        let result = f();
        bcs::to_bytes(&result)
    }

    // Function to test, wraps a lambda (a zero-argument function returning u64)
    public fun run_test(): bool {
        let nested_lambda = || {
            || {
                100
            }
        };

        // Use the higher-order function to serialize the nested_lambda
        let bytes = apply_and_serialize::<|| u64>(nested_lambda);
        // Also serialize the inner lambda again directly
        let direct_bytes = bcs::to_bytes(&nested_lambda);

        bytes == direct_bytes
    }
}

///# run 0xabcde::byte_serialization_hof::run_test

//# publish
module 0xabcde::higher_order_and_bytes {
    use std::vector;

    // Function that creates deeply nested lambdas and serializes them
    public fun create_deep_lambda_chain(): vector<u8> {
        let depth = 5;
        // Generate nested lambdas dynamically
        let rec build_chain = |n: u64| {
            if n > 0 {
                || build_chain(n - 1)
            } else {
                || {
                    999
                }
            }
        };
        let deep_lambda = build_chain(depth);
        // Serialize the nested lambda
        bcs::to_bytes(&deep_lambda)
    }

    // Function that takes nested lambdas, applies a function, and modifies values in lambda's context (simulated)
    public fun apply_higher_order(): bool {
        // Create a nested lambda
        let nested = || {
            || {
                55
            }
        };

        // Serialize and then deserialize to verify serialization correctness
        let serialized = bcs::to_bytes(&nested);
        let deserialized: || || u64 = bcs::from_bytes(&serialized).unwrap();

        // Run deserialized lambda
        let value = deserialized();
        value == 55
    }
}

///# run 0xabcde::higher_order_and_bytes::create_deep_lambda_chain
///# run 0xabcde::higher_order_and_bytes::apply_higher_order