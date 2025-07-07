//# publish
module 0x42::nested_enum_test {
    struct HelperStruct<A, B>(A, B) has drop;

    enum NestedEnum has drop {
        VariantA(u8, HelperStruct<u8, bool>),
        VariantB {
            x: u8,
            y: HelperStruct<u8, bool>,
        },
        VariantC {
            first_field: u8,
            nested_enum: Option<NestedEnum>,
        }
    }

    fun get_first_u8_from_variantA(x: &NestedEnum): u8 {
        match (x) {
            NestedEnum::VariantA(a, ..) => *a,
            NestedEnum::VariantB { x, .. } => *x,
            NestedEnum::VariantC { first_field, .. } => *first_field,
        }
    }

    fun get_inner_u8_from_variantB(x: &NestedEnum): u8 {
        match (x) {
            NestedEnum::VariantA(_, HelperStruct(_, y)) => *y,
            NestedEnum::VariantB { y, .. } => *y,
            NestedEnum::VariantC { nested_enum: Some(nested), .. } => {
                get_first_u8_from_variantA(nested)
            },
            NestedEnum::VariantC { nested_enum: None, .. } => 0,
        }
    }

    fun test_variantA(): u8 {
        let x = NestedEnum::VariantA(10, HelperStruct(20, true));
        get_first_u8_from_variantA(&x)
    }

    fun test_variantB(): u8 {
        let x = NestedEnum::VariantB { x: 30, y: HelperStruct(40, false) };
        get_inner_u8_from_variantB(&x)
    }

    fun test_variantC_with_nested(): u8 {
        let nested = NestedEnum::VariantA(50, HelperStruct(60, true));
        let x = NestedEnum::VariantC { first_field: 70, nested_enum: Some(nested) };
        get_inner_u8_from_variantB(&x)
    }

    fun test_variantC_without_nested(): u8 {
        let x = NestedEnum::VariantC { first_field: 80, nested_enum: None };
        get_inner_u8_from_variantB(&x)
    }
}

//# run --verbose -- 0x42::nested_enum_test::test_variantA
//# run --verbose -- 0x42::nested_enum_test::test_variantB
//# run --verbose -- 0x42::nested_enum_test::test_variantC_with_nested
//# run --verbose -- 0x42::nested_enum_test::test_variantC_without_nested