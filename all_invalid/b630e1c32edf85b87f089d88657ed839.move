
//# publish
module 0xCAFE::AdvancedFeatures {
    // Removed unused `use std::signer;`

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

    // Added `copy` to function parameter type for closures that need to be copied
    public fun closure_as_parameter_apply_twice(op: copy |u8| u8, val: u8): u8 {
        let intermediate = op(val);
        op(intermediate)
    }

    public fun closure_inline_execution(x: u8): u8 {
        let f: copy |u8| u8 = |z: u8| { z + 1 };
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

    // Added `copy` to `op` parameter to allow multiple uses
    public fun closure_returning_struct(op: copy |u8| u8, val: u8): NamedFieldsStruct {
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
