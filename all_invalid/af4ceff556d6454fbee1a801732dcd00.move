
//# publish
module 0xCAFE::AttrOptionalCopyPropagation {
    use std::vector;
    use std::signer;

    // NATIVE_INTERFACE]
    public fun native_function_no_type_anno(a, b) {
        // No type annotations in parameters
        let _x = a;
        let _y = b;
    }

    // NATIVE_INTERFACE]
    public fun native_function_with_type_anno(a: u8, b: bool) {
        let _x: u8 = a;
        let _y: bool = b;
    }

    // NATIVE_INTERFACE]
    public(native) fun native_function_with_body(a: u8, b: bool) {
        let _x: u8 = a;
        let y = b;
        while (y) {
            y = false;
        };
    }

    public fun optional_type_annotations() {
        let a = 1u8;
        let b: u16 = 2u16;
        let c = true;
        let d: bool = false;

        let _sum: u32 = (a as u32) + (b as u32);
        let _flag = c || d;

        let (x, y): (u8, u8) = self::swap(a, a + 1);
        if (x < y) {
            let _z: u8 = y;
        };
    }

    public inline fun swap(x: u8, y: u8): (u8, u8) {
        (y, x)
    }

    public fun copy_propagation_test(a: u8) {
        let x: u8 = a;
        let y = 0u8;
        while (x < 5) {
            y = x;
            x = x + 1;
        };
        let z = y; // test copy propagation; y is last value assigned inside loop

        let p: u8 = z;
        while (p > 0) {
            p = p - 1;
        };
        let q = p; // test copy propagation after loop

        let _ = (z, q);
    }

    public fun aliasing_and_reassignment() {
        let v: u8 = 10;
        let w: u8 = v;
        while (v > 0) {
            w = v;
            v = v - 2;
        };
        let _ = w;

        let a: u8 = 1;
        let b = a as u8;
        while (a < 5) {
            let c: u8 = b;
            b = c + 1;
            a = a + 1;
        };
        let _ = (a, b);
    }

    // NATIVE_INTERFACE]
    public fun native_with_loop_reassignment(mut x: u8) {
        while (x > 0) {
            x = x - 1;
        };
    }

    // Negative test for attribute misuse (commented out because it will fail compiler)
    // // native_interface] // incorrect attribute casing
    // public fun bad_attribute() {}

    // Negative test for wrong type annotations (commented out because it will fail compiler)
    // public fun bad_type_annotation(x: unknown) {}
}


//# run 0xCAFE::AttrOptionalCopyPropagation::native_function_no_type_anno --args 7u8 0u8


//# run 0xCAFE::AttrOptionalCopyPropagation::native_function_with_type_anno --args 3u8 1


//# run 0xCAFE::AttrOptionalCopyPropagation::native_function_with_body --args 10u8 1


//# run 0xCAFE::AttrOptionalCopyPropagation::optional_type_annotations


//# run 0xCAFE::AttrOptionalCopyPropagation::copy_propagation_test --args 0u8


//# run 0xCAFE::AttrOptionalCopyPropagation::aliasing_and_reassignment


//# run 0xCAFE::AttrOptionalCopyPropagation::native_with_loop_reassignment --args 15u8


// Featurres:
// a4ab16b1f1217107bb207d87ca9cfe63: Apply custom attributes like '#[NATIVE_INTERFACE]' to functions.
// a5c84d032745059d9fa4c06e58019377: Use optional type annotations when defining functions or variables to indicate that they may or may not have a type specified.
// ad6c094e5976bada1aee54df5600a8c7: Verify that variable assignments inside a while loop do not affect the availability of copy propagation for variables after the loop.
