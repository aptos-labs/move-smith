
//# publish
module 0xCAFE::SpannedValue {
    // Module to define Spanned struct and source location metadata

    struct Location has copy, drop, store {
        line: u64,
        column: u64,
    }

    struct Spanned<T> has copy, drop, store {
        value: T,
        location: Location,
    }

    public fun new_location(line: u64, column: u64): Location {
        Location { line, column }
    }

    public fun new_spanned<T>(value: T, line: u64, column: u64): Spanned<T> {
        Spanned {
            value,
            location: new_location(line, column)
        }
    }

    public fun get_location<T>(s: &Spanned<T>): &Location {
        &s.location
    }

    public fun get_value<T>(s: &Spanned<T>): &T {
        &s.value
    }
}



//# run 0xCAFE::SpannedValue::new_spanned --args 123u64 45u64


//# run 0xCAFE::SpannedValue::get_location --args 123u64 45u64


//# run 0xCAFE::SpannedValue::get_value --args 123u64 45u64



//# publish
module 0xCAFE::AdvancedPattern {
    // Removed unused import "vector"

    struct Inner has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Outer has copy, drop, store {
        x: Inner,
        y: u8,
        z: u8,
    }

    struct Partial has copy, drop, store {
        m: u8,
        n: u8,
    }

    public fun unpack_all_fields(o: Outer): u8 {
        let Outer { x: Inner { a, b }, y, z } = o;
        a + b + y + z
    }

    public fun unpack_some_fields(o: Outer): u8 {
        let Outer { x: Inner { a, .. }, y, .. } = o;
        a + y
    }

    public fun unpack_no_fields(o: Outer): u8 {
        let Outer { .. } = o;
        10
    }

    public fun unpack_partial_struct(p: Partial): u8 {
        let Partial { m, .. } = p;
        m
    }
}



//# run 0xCAFE::AdvancedPattern::unpack_all_fields --args 0u8 0u8 0u8 0u8


//# run 0xCAFE::AdvancedPattern::unpack_some_fields --args 0u8 0u8 0u8 0u8


//# run 0xCAFE::AdvancedPattern::unpack_no_fields --args 0u8 0u8 0u8 0u8


//# run 0xCAFE::AdvancedPattern::unpack_partial_struct --args 0u8 0u8



//# publish
module 0xCAFE::DynamicFieldAddition {
    use 0xCAFE::SpannedValue;

    struct BaseSingleton has copy, drop, store {
        id: u64,
    }

    struct NewFieldType has copy, drop, store {
        val: u8,
    }

    struct SingletonWithNewField has copy, drop, store {
        id: u64,
        extra: NewFieldType,
    }

    public fun add_field_to_singleton(b: BaseSingleton, val: u8): SingletonWithNewField {
        let nf = NewFieldType { val };
        SingletonWithNewField { id: b.id, extra: nf }
    }

    enum Variant {
        V0,
        V1 { a: u8 },
    }

    struct VariantWithNewField has copy, drop, store {
        variant: Variant,
        extra: NewFieldType,
    }

    public fun add_field_to_variant(v: Variant, val: u8): VariantWithNewField {
        let nf = NewFieldType { val };
        VariantWithNewField { variant: v, extra: nf }
    }

    public fun unpack_variant_with_extra(v: VariantWithNewField): u8 {
        let VariantWithNewField { variant, extra } = v;
        let val = {
            match variant {
                Variant::V0 => 0,
                Variant::V1 { a } => a,
            }
        };
        val + extra.val
    }
}



//# run 0xCAFE::DynamicFieldAddition::add_field_to_singleton --args 10u64 99u8



//# run 0xCAFE::DynamicFieldAddition::add_field_to_variant --args 0u8 77u8


//# run 0xCAFE::DynamicFieldAddition::unpack_variant_with_extra --args 0u8 77u8



//# publish
module 0xCAFE::IntegrationTest {
    use 0xCAFE::SpannedValue;
    use 0xCAFE::DynamicFieldAddition;

    struct LocStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct LocStructWithExtra has copy, drop, store {
        base: LocStruct,
        extra: DynamicFieldAddition::NewFieldType,
    }

    public fun create_spanned_loc_struct(a: u8, b: u8, line: u64, col: u64): SpannedValue::Spanned<LocStruct> {
        let ls = LocStruct { a, b };
        SpannedValue::new_spanned<LocStruct>(ls, line, col)
    }

    public fun create_spanned_loc_struct_with_extra(a: u8, b: u8, val: u8, line: u64, col: u64): SpannedValue::Spanned<LocStructWithExtra> {
        let base = LocStruct { a, b };
        let extra = DynamicFieldAddition::NewFieldType { val };
        let full = LocStructWithExtra { base, extra };
        SpannedValue::new_spanned<LocStructWithExtra>(full, line, col)
    }

    public fun unpack_spanned_loc_struct(s: SpannedValue::Spanned<LocStruct>): u8 {
        let LocStruct { a, .. } = s.value;
        a + (s.location.line as u8) + (s.location.column as u8)
    }

    public fun unpack_spanned_loc_struct_with_extra(s: SpannedValue::Spanned<LocStructWithExtra>): u8 {
        let LocStructWithExtra { base: LocStruct { a, .. }, extra } = s.value;
        a + extra.val + (s.location.line as u8) + (s.location.column as u8)
    }
}



//# run 0xCAFE::IntegrationTest::create_spanned_loc_struct --args 5u8 6u8 100u64 200u64


//# run 0xCAFE::IntegrationTest::unpack_spanned_loc_struct --args 5u8 6u8 100u64 200u64



//# run 0xCAFE::IntegrationTest::create_spanned_loc_struct_with_extra --args 7u8 8u8 15u8 50u64 51u64


//# run 0xCAFE::IntegrationTest::unpack_spanned_loc_struct_with_extra --args 7u8 8u8 15u8 50u64 51u64
