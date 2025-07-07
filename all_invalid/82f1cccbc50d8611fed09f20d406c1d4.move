
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;
    use std::option;
    use std::enum;

    // Define enum with multiple variants for pattern matching
    enum VariantType has copy, drop {
        VSingle,
        VMultiple(u32, bool),
        VWithStruct { flag: bool },
        VWithOption(option::Option<u8>),
    }

    // Struct to be used in tuple-like collections
    struct ComplexStruct has copy, drop {
        id: u64,
        active: bool,
        label: vector<u8>,
    }

    // Function to create nested tuple/list with diverse types
    public fun create_multi_value_list(): (u64, bool, vector<u8>, Option::Option<u8>, VariantType, ComplexStruct) {
        let complex = ComplexStruct {
            id: 12345,
            active: true,
            label: b"test",
        };
        let variant = VariantType::VMultiple(42, false);
        let option_value = option::some<u8>(255);

        (9876543210u64, true, b"Move", option_value, variant, complex)
    }

    // Function to pattern match on enum with multiple variants, including | operator
    public fun match_variant(v: VariantType): u8 {
        if (v is VariantType::VSingle) {
            1
        } else if (v is VariantType::VMultiple) {
            2
        } else if (v is VariantType::VWithStruct) {
            3
        } else if (v is VariantType::VWithOption) {
            4
        } else {
            0
        }
    }

    // Function to test pattern matching on combined variants using `|` operator
    public fun match_multiple_variants(v: VariantType): u8 {
        if (v is VariantType::VSingle | VariantType::VMultiple(_, _)) {
            10
        } else if (v is VariantType::VWithStruct) {
            20
        } else if (v is VariantType::VWithOption) {
            30
        } else {
            0
        }
    }

    // Function that returns a non-function type, conditionally compiled execution
    // Suppose environment disables function return types; here we just show the function
    public fun non_function_return(): u64 {
        999
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::create_multi_value_list


//# run 0xCAFE::AdvancedFeaturesTest::match_variant --args 0 // testing VSingle

//# run 0xCAFE::AdvancedFeaturesTest::match_variant --args 1 // testing VMultiple

//# run 0xCAFE::AdvancedFeaturesTest::match_variant --args 2 // testing VWithStruct

//# run 0xCAFE::AdvancedFeaturesTest::match_variant --args 3 // testing VWithOption


//# run 0xCAFE::AdvancedFeaturesTest::match_multiple_variants --args 0 // testing single

//# run 0xCAFE::AdvancedFeaturesTest::match_multiple_variants --args 1 // testing multiple (VSingle or VMultiple)


// Featurres:
// 25c15f69e7c925a2f6451b6abc0f3011: Create multi-value expression lists (tuples or similar).
// 8d19e99307df753b6e2e899f269976ce: Test that pattern matching using the `is` operator correctly identifies specific enum variants and supports matching multiple variants with the `|` operator.
// c59529a48b9010cbea2c450960d883a7: Declare functions that do not return function-typed values unless allowed by the environment options.
