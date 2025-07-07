
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun add_and_return_fixed_value(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }
}



//# run 0xCAFE::TestAddition::add_and_return_sum --args 10u8 15u8



//# run 0xCAFE::TestAddition::add_and_return_fixed_value --args 10u8 15u8




//# publish
module 0xCAFE::LambdaFunctions {
    public fun lambda_identity(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| a;
        f(x)
    }

    public fun lambda_add_multiply(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::LambdaFunctions::lambda_identity --args 55u8



//# run 0xCAFE::LambdaFunctions::lambda_add_multiply --args 6u8 7u8




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::TestAddition;

    public inline fun inline_add_twice(a: u8, b: u8): u8 {
        let first_sum = TestAddition::add_and_return_sum(a, b);
        let second_sum = TestAddition::add_and_return_sum(first_sum, 1u8);
        second_sum
    }

    public fun call_inline_add_twice(): u8 {
        inline_add_twice(10u8, 20u8)
    }
}



//# run 0xCAFE::NestedCalls::call_inline_add_twice




//# publish
module 0xCAFE::TypeAnalysis {
    use std::vector;

    // Struct with various types
    struct SampleStruct has copy, drop, store {
        a: u8,
        b: u64,
        c: bool,
        d: vector<u8>,
    }

    // Enum with variants of different types
    enum SampleEnum has copy, drop {
        Unit,
        U32Val(u32),
        VecVal { v: vector<u64> }
    }

    // We create dummy functions to "inspect" the base types of each field
    // by just returning bool to indicate successful access
    
    public fun analyze_struct_field_a(s: &SampleStruct): bool {
        // Should be u8, here we do a comparison with 0 to confirm type accessibility
        s.a > 0u8
    }
    
    public fun analyze_struct_field_b(s: &SampleStruct): bool {
        // Should be u64, test numeric comparison
        s.b > 0u64
    }

    public fun analyze_struct_field_c(s: &SampleStruct): bool {
        // Should be bool
        s.c
    }

    public fun analyze_struct_field_d(s: &SampleStruct): u8 {
        // Should be vector<u8>, return first element or 0 if empty
        if (vector::is_empty(&s.d)) {
            0u8
        } else {
            *vector::borrow(&s.d, 0)
        }
    }

    public fun analyze_enum_variant(e: SampleEnum): u8 {
        match (e) {
            SampleEnum::Unit => 1u8,
            SampleEnum::U32Val(x) => x as u8,
            SampleEnum::VecVal { v } => {
                if (vector::is_empty(&v)) {
                    0u8
                } else {
                    *vector::borrow(&v, 0) as u8
                }
            },
        }
    }

    public fun create_sample_struct(): SampleStruct {
        SampleStruct {
            a: 5u8,
            b: 123u64,
            c: true,
            d: vector[10u8, 20u8, 30u8],
        }
    }

    public fun create_sample_enum_unit(): SampleEnum {
        SampleEnum::Unit
    }

    public fun create_sample_enum_u32(): SampleEnum {
        SampleEnum::U32Val(200u32)
    }

    public fun create_sample_enum_vec(): SampleEnum {
        SampleEnum::VecVal { v: vector[100u64, 200u64] }
    }
}



//# run 0xCAFE::TypeAnalysis::analyze_struct_field_a --args 0xCAFE



//# run 0xCAFE::TypeAnalysis::analyze_struct_field_b --args 0xCAFE



//# run 0xCAFE::TypeAnalysis::analyze_struct_field_c --args 0xCAFE



//# run 0xCAFE::TypeAnalysis::analyze_struct_field_d --args 0xCAFE



//# run 0xCAFE::TypeAnalysis::analyze_enum_variant --args 0xCAFE



//# run 0xCAFE::TypeAnalysis::create_sample_struct



//# run 0xCAFE::TypeAnalysis::create_sample_enum_unit



//# run 0xCAFE::TypeAnalysis::create_sample_enum_u32



//# run 0xCAFE::TypeAnalysis::create_sample_enum_vec
