
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

    // Function returning multiple values by output parameters instead of a tuple
    // Since tuples can't be used as type arguments or assigned directly
    public fun multi_return_example(out_a: &mut u64, out_b: &mut bool, out_c: &mut u8) {
        *out_a = 123u64;
        *out_b = true;
        *out_c = 42u8;
    }

    // Function testing multi-variable binding by destructuring using mutable references
    public fun test_multi_bindings(out_sum: &mut u64, out_c: &mut u8) {
        let a: u64 = 0;
        let b: bool = false;
        let c: u8 = 0;
        multi_return_example(&mut a, &mut b, &mut c);
        *out_sum = a + (c as u64);
        *out_c = c;
    }

    // Function testing generic struct and multi-variable bindings together
    public fun complex_generic_and_bindings(out_r1: &mut u8, out_r2: &mut u8) {
        // Create generic native wrapping u8
        let g1 = create_generic_u8(10u8);
        // Create generic native wrapping NativeEmpty
        let _g2 = create_generic_native_empty();
        // Multi-variable binding with mutable refs
        let sum: u64 = 0;
        let val: u8 = 0;
        test_multi_bindings(&mut sum, &mut val);
        // Use fields and values to produce some u8 results
        *out_r1 = g1.value + val;
        *out_r2 = (sum as u8) + 1;
    }

    // Runner function without arguments to call all above test functions
    public fun runner() {
        let _e = create_native_empty();
        let _g_u8 = create_generic_u8(5u8);
        let _g_n = create_generic_native_empty();

        // Call multi_return_example using mutable locals
        let a: u64 = 0;
        let b: bool = false;
        let c: u8 = 0;
        multi_return_example(&mut a, &mut b, &mut c);

        // Call test_multi_bindings
        let sum: u64 = 0;
        let c2: u8 = 0;
        test_multi_bindings(&mut sum, &mut c2);

        // Call complex_generic_and_bindings
        let r1: u8 = 0;
        let r2: u8 = 0;
        complex_generic_and_bindings(&mut r1, &mut r2);
    }
}



//# run 0xCAFE::AdvancedFeatures::runner


// Features:
// e09532b2122bc1456e92219e9f2a0683: Include native structs without field declarations.
// 23d28765e83d1c28a76e0128b07aa18d: Declare type parameters for structs using angle brackets '<' and '>'
// 1906cb0341c5279da7dce89c8d5e75fb: Bind the results of an expression to multiple local variables using lvalues in assignments and patterns
