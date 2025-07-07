//# publish
module 0xCAFE::FeatureFlag {
    // Store feature flags as a global bitset
    use std::signer::{Signer}; // Correct import for Signer
    // Store feature flags as a global bitset
    struct Flag has key, store {
        bitset: u64,
    }

    // Initialize the feature flag resource
    public fun init(account: &signer) {
        move_to(account, Flag { bitset: 0 })
    }

    // Enable a feature bit
    public fun enable_feature(account: &signer, feature_bit: u8) {
        let flag_ref = borrow_global_mut<Flag>(Signer::address_of(account));
        let new_bits = flag_ref.bitset | (1 << feature_bit);
        flag_ref.bitset = new_bits;
    }

    // Check if a feature is enabled
    public fun is_feature_enabled(account: &signer, feature_bit: u8): bool {
        let flag_ref = borrow_global<Flag>(Signer::address_of(account));
        (flag_ref.bitset & (1 << feature_bit)) != 0
    }
}

//# publish
module 0xCAFE::NestedStructTest {
    // Define nested structs for unpacking
    struct InnerStruct has copy, drop {
        a: u64,
        b: bool,
    }

    struct OuterStruct has copy, drop {
        x: u32,
        inner: InnerStruct,
        y: u8,
    }

    // Function to process unpacking of nested struct
    public fun process_structs(
        outer: OuterStruct,
        inner_ref: &InnerStruct,
    ): (u64, bool, u8) {
        // Unpack outer
        let OuterStruct { x: _, inner: inner, y: _ } = outer;
        // Unpack inner
        let InnerStruct { a, b } = inner;
        // Structural unpacking of references
        let InnerStruct { a: a_ref, b: b_ref } = *inner_ref;

        // Combine some values for demonstration
        (a, b, y)
    }

    // Runner function to test the unpacking
    public fun run_unpacking() {
        // Create nested structs
        let inner = InnerStruct { a: 42, b: true };
        let outer = OuterStruct { x: 999, inner: inner, y: 255 };

        // Call process_structs with owned and referenced inner struct
        let (a_val, b_val, y_val) = process_structs(outer, &inner);

        // No assertions per instructions
        // Return to avoid unused variable warnings
        return;
    }
}

//# run 0xCAFE::NestedStructTest::run_unpacking

// Featurres:
// f2ddebe7ab5d5fec40a8fffc3a2b297b: Process positional unpacking of struct fields in Move code, including nested unpacking of variable references.
// 895804f89d3a1d497ce41bbd9d9395e2: Use 'public' visibility for functions accessible from any module.
// 6efb91f6b17991583221a858d3041514: Test that enabling a specific feature flag correctly updates the on-chain bitset to reflect only the intended feature as enabled, without affecting the state of other feature flags.
