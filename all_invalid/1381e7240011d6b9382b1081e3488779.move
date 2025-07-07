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
    // Move 'internal' functions outside of 'pub' functions without the 'internal' keyword
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Public function that uses internal helper
    public fun use_internal_helper() {
        let res = internal_helper(10u8);
        // just to use 'res'
        res
    }
}