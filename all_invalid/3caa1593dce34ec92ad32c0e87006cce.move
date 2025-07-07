//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    struct Data has store, key {
        value: u64
    }

    #[test_only]
    public fun test_only_function() {
        // This function is only usable in test environment
        // no return, no args
    }

    native fun native_add(a: u64, b: u64): u64;

    public fun test_native_wrapper(a: u64, b: u64): u64 {
        native_add(a, b)
    }

    // Store data resource at caller address
    public fun store_value(s: signer, v: u64) {
        let data = Data {value: v};
        move_to<Data>(&s, data);
    }

    public fun get_value(s: signer): u64 {
        let data_ref = borrow_global<Data>(signer::address_of(&s));
        data_ref.value
    }
}

//# run 0xCAFE::FeatureTest::test_only_function

//# run 0xCAFE::FeatureTest::store_value --signers 0xBABA --args 100u64

//# run 0xCAFE::FeatureTest::get_value --signers 0xBABA

//# run 0xCAFE::FeatureTest::test_native_wrapper --args 40u64 2u64

// Featurres:
// 50c36c2eb027d9822b4985ebe0d099de: Annotate test functions with #[test_only] to restrict their use for certain purposes, but not in combination with #[test].
// 79f4b64c36549fba3df604c25d30db9f: Define packages using symbolic names and symbolic package paths instead of string-based identifiers
// 23028a622093b2d13fc6c7bf2bb93f16: Mark functions as native to indicate they are implemented outside Move language.
