
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // 1. Define functions for feature testing

    // Function to convert location range (start, end) to byte range within source code
    // (Simply simulate with passing in start and end positions and returning as a tuple)
    public fun location_range_to_byte_range(start: u64, end: u64): (u64, u64) {
        (start, end)
    }

    // 2. Define a struct with type parameter as type argument
    struct Container<T> has copy, drop, store {
        value: T,
    }

    // 3. Define an internal function to restrict access within this module
    internal fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Public function that uses internal helper
    public fun use_internal_helper() {
        let res = internal_helper(10u8);
        // just to use 'res'
        res
    }
}


//# run 0xCAFE::FeatureTest::location_range_to_byte_range --args 5u64 15u64


//# run 0xCAFE::FeatureTest::use_internal_helper

// Featurres:
// 88b39f65af0c16f5a55e26ae3f405a74: Convert a location's range to a range of byte positions within a source file.
// c4af56f7e8ef0854238512e39b8ef9b0: Define struct types with type parameters as type arguments
// b1f39d5c0e3a28a402ed8c63ae04e44a: Declare functions or modules with 'internal' visibility to restrict access to the current module only.
