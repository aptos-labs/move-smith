
//# publish
module 0xCAFE::AdvancedFeatures {
    // Testing Native Struct without fields
    struct NativeEmpty has drop, store {}

    // Generic struct with type parameter
    struct GenericNative<T> has store {
        value: T
    }

    // Function to create and return an empty native struct
    public fun create_native_empty(): NativeEmpty {
        NativeEmpty {}
    }

    // Function to create a generic native struct wrapping u8
    public fun create_generic_u8(val: u8): GenericNative<u8> {
        GenericNative<u8> { value: val }
    }

    // Function to create a generic native struct wrapping NativeEmpty
    public fun create_generic_native_empty(): GenericNative<NativeEmpty> {
        let e = create_native_empty();
        GenericNative<NativeEmpty> { value: e }
    }

    // Function returning multiple values as tuple: (u64, bool, u8)
    public fun multi_return_example(): (u64, bool, u8) {
        (123u64, true, 42u8)
    }

    // Function testing multi-variable binding by destructuring a tuple
    public fun test_multi_bindings(): (u64, u8) {
        let (a, b, c) = multi_return_example();
        // Return sum of a and cast c to u64, and c as u8 separately
        (a + (c as u64), c)
    }

    // Function testing generic struct and multi-variable bindings together
    public fun complex_generic_and_bindings(): (u8, u8) {
        // Create generic native wrapping u8
        let g1 = create_generic_u8(10u8);
        // Create generic native wrapping NativeEmpty
        let g2 = create_generic_native_empty();
        // Multi-variable binding with tuple
        let (sum, val) = test_multi_bindings();
        // Use fields and values to produce some u8 results
        let r1 = g1.value + (val);
        let r2 = (sum as u8) + 1;
        (r1, r2)
    }

    // Runner function without arguments to call all above test functions
    public fun runner() {
        let _e = create_native_empty();
        let _g_u8 = create_generic_u8(5u8);
        let _g_n = create_generic_native_empty();
        let _ = multi_return_example();
        let _ = test_multi_bindings();
        let _ = complex_generic_and_bindings();
    }
}


//# run 0xCAFE::AdvancedFeatures::runner


// Featurres:
// e09532b2122bc1456e92219e9f2a0683: Include native structs without field declarations.
// 23d28765e83d1c28a76e0128b07aa18d: Declare type parameters for structs using angle brackets '<' and '>'
// 1906cb0341c5279da7dce89c8d5e75fb: Bind the results of an expression to multiple local variables using lvalues in assignments and patterns
