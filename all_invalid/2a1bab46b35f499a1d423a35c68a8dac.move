// transactional_test.move

address 0x1 {
    module TestCompilerFeatures {
        use std::signer;
        use std::vector;

        // 1: Using the #[verify_only] attribute on a function and a module item
        #[verify_only]
        public fun verify_only_function(): u64 {
            // This function is only for verification, not for deployment/execution
            42
        }

        #[verify_only]
        const VERIFY_ONLY_CONST: u64 = 123;

        // 2: Deprecated annotation on module members

        #[deprecated(reason = "Use new_function instead")]
        public fun old_function(): u64 {
            1
        }

        #[deprecated(reason = "Old constant, use NEW_CONST")]
        const OLD_CONST: u64 = 100;

        const NEW_CONST: u64 = 200;

        #[deprecated(reason = "Old struct, use NewStruct")]
        struct OldStruct has store {
            value: u64,
        }

        struct NewStruct has store {
            value: u64,
        }

        // 3: A function whose body is rewritten using custom expression transformations

        // The original function (for illustration, the body will be rewritten)
        public fun calculate_sum(v: vector<u64>): u64 {
            let mut result = 0;
            let length = vector::length(&v);
            let mut i = 0;
            while (i < length) {
                result = result + *vector::borrow(&v, i);
                i = i + 1;
            }
            result
        }

        // After "custom expression transformation", we rewrite the body manually here:
        // Here we simulate replacing the loop with a fold-like pattern explicitly
        public fun calculate_sum_rewritten(v: vector<u64>): u64 {
            // Manually unrolled fold to sum all elements
            vector::fold<u64, u64>(&v, 0, fun (acc: u64, item: &u64): u64 {
                acc + *item
            })
        }

    }
}

// Transactional test block to test above features
test verify_test_compiler_features() {
    use 0x1::TestCompilerFeatures;
    use std::debug;

    // 1: Verify #[verify_only] functions and constants can be referenced in specs (simulate)
    // Note: In Move, #[verify_only] items may not be callable at runtime, but we can test their visibility in "verification" scope.

    // Assert the constant
    debug::assert(TestCompilerFeatures::VERIFY_ONLY_CONST == 123, 1);

    // Can't call verify_only_function() normally, but assuming a verification environment could

    // 2: Access deprecated members (should emit deprecation warnings in compiler if supported)
    let old_val = TestCompilerFeatures::old_function();
    debug::assert(old_val == 1, 2);

    let old_const_val = TestCompilerFeatures::OLD_CONST;
    debug::assert(old_const_val == 100, 3);

    // 3: Test that original and rewritten function produce same results

    let vec = vector::empty<u64>();
    let vec = vector::push_back(vec, 10);
    let vec = vector::push_back(vec, 20);
    let vec = vector::push_back(vec, 30);

    let sum1 = TestCompilerFeatures::calculate_sum(vec);
    let sum2 = TestCompilerFeatures::calculate_sum_rewritten(vec);

    debug::assert(sum1 == 60, 4);
    debug::assert(sum2 == 60, 5);
    debug::assert(sum1 == sum2, 6);
}

// Featurres:
// c62bb3e584566505b6ce583c407ff80c: Annotate Move functions, modules, or items with the #[verify_only] attribute to indicate that they should be used only for verification purposes and not included in normal execution.
// a2d7fbb8193d7979e093ba1c6ea49a06: Annotate module members with deprecated annotations
// 8e35eac200d8d34602f19bfe926589bb: Rewrite the body of a Move function using custom expression transformations.
