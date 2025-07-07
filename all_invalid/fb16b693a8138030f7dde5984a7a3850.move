
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
        }: {a: u8, b: u16, c: bool};
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
        let sum = local1 + local2.f64().to_u64(); // convert u8 to u64 for addition
        // Reuse the values
        let product = local1 * local2;

        // Prepare a structure with dot access
        let my_struct = {
            field1: local1,
            field2: local2,
        }: {field1: u8, field2: u8};

        // Return the sum and product
        (sum, product, my_struct)
    }

    // Helper function returning a tuple
    public fun f_return_tuple(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }
}

// -----------------
// Transactional scripts to test features
// -----------------


//# run 0xBABE::TestModule::create_struct_with_fields

//# run 0xBABE::TestModule::compute_and_use


// Featurres:
// 2f2e974fce4b9f14ce6352e0160ea7f8:  Pack named fields into a structure by enclosing comma-separated field expressions within braces '{' and '}', following a name.
// 2a06a5c3c4311fb5835a792534913bac: Test that values returned from a function are properly saved to locals and managed on the stack when they must be used multiple times in subsequent operations.
// e3b75d75b043a543f9b015c19d7f6435: Use dot access to access fields or methods with `e.f`.
