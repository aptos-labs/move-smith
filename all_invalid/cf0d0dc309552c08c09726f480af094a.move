
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::signer;

    struct MixedInts has copy, drop, store {
        a: u8,
        b: u64,
        c: u128,
    }

    struct NamedFieldsStruct has copy, drop, store {
        x: u64,
        y: u128,
    }

    // Struct with brace-enclosed named fields, similar to variant style
    struct VariantStyle has copy, drop, store {
        val1: u8,
        val2: u128,
    }

    public fun closure_as_parameter_apply_twice(op: |u8| u8, val: u8): u8 {
        let intermediate = op(val);
        op(intermediate)
    }

    public fun closure_inline_execution(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |z: u8| { z + 1 };
        f(x)
    }

    public fun return_struct_with_literals(): MixedInts {
        MixedInts {
            a: 10u8,
            b: 1000u64,
            c: 1_000_000u128,
        }
    }

    public fun return_struct_with_locals(): MixedInts {
        let local_a = 20u8;
        let local_b = 2000u64;
        let local_c = 2_000_000u128;
        MixedInts {
            a: local_a,
            b: local_b,
            c: local_c,
        }
    }

    public fun construct_variant_style(): VariantStyle {
        VariantStyle {
            val1: 255u8,
            val2: 999_999u128,
        }
    }

    public fun access_variant_fields(v: &VariantStyle): (u8, u128) {
        (v.val1, v.val2)
    }

    public fun closure_returning_struct(op: |u8| u8, val: u8): NamedFieldsStruct {
        let x_val = op(val) as u64;
        let y_val = (val as u128) * 10u128;
        NamedFieldsStruct {
            x: x_val,
            y: y_val,
        }
    }
}


//# run 0xCAFE::AdvancedFeatures::closure_as_parameter_apply_twice --args 4u8 10u8


//# run 0xCAFE::AdvancedFeatures::closure_inline_execution --args 7u8


//# run 0xCAFE::AdvancedFeatures::return_struct_with_literals


//# run 0xCAFE::AdvancedFeatures::return_struct_with_locals


//# run 0xCAFE::AdvancedFeatures::construct_variant_style


//# run 0xCAFE::AdvancedFeatures::access_variant_fields --args 0xCAFE


//# run 0xCAFE::AdvancedFeatures::closure_returning_struct --args 11u8 5u8


// Featurres:
// 311e0558502fb24c09fb270a9f8f0e34: Test that function parameters can accept and execute closures as first-class values, including passing closures as arguments to other functions.
// 90826b291d5a9bbded1a82a5f81d9db9: Test that a function can correctly construct and return a struct with multiple fields of different integer types, initializing its fields with local variables and literals.
// 155007288c9ed8bcacb4766bb2688942: Define struct variants with named fields using braces ({ ... })
