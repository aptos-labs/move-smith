//# publish
module 0xBABE::TestModule {
    use std::vector;

    // -----------------
    // Feature 1: Pack named fields into a structure
    // -----------------
    public fun create_struct_with_fields() {
        let s = {
            a: 10u8,
            b: 20u16,
            c: true
        }; // Fixed: Changed from ':' to ';'
        s
    }

    // -----------------
    // Feature 2 & 3: Function returns value, assign to locals, reuse, and dot access
    // -----------------
    public fun compute_and_use() {
        // Use a simple function returning a tuple
        let (val1, val2) = f_return_tuple(42u8);
        // Save the returned values into separate locals
        let local1 = val1;
        let local2 = val2;

        // Use dot access to perform operations
        // Note: 'f64()' is not a valid method for u8, this was likely intended as a cast.
        // Adjusted to cast local1 (u8) to u64 directly.
        let sum = local1 + (local2 as u64); // If the intention was to convert local2 to u64
        // Alternatively, if local1's u8 to u64:
        // let sum = (local1 as u64) + (local2 as u64);

        // Use the correct types for product
        let product = local1 * local2;

        // Prepare a structure with dot access
        let my_struct = {
            field1: local1,
            field2: local2,
        };

        // Return the sum and product
        (sum, product, my_struct)
    }

    // Helper function returning a tuple
    public fun f_return_tuple(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }
}
