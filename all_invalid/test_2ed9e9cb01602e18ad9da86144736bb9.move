//# publish
module 0x99::nested_enum {
    struct InnerStruct<A, B> has drop {
        field1: A,
        field2: B
    }

    enum NestedEnum has drop {
        VariantA(u8, InnerStruct<u8, bool>),
        VariantB {
            number: u8,
            inner: InnerStruct<u8, bool>
        }
    }

    fun get_first_u8(e: &NestedEnum): u8 {
        match (e) {
            NestedEnum::VariantA(val, ..) => *val,
            NestedEnum::VariantB { number, .. } => *number,
        }
    }

    fun get_second_u8(e: &NestedEnum): u8 {
        match (e) {
            NestedEnum::VariantA(_, InnerStruct { field1: f1, .. }) => *f1,
            NestedEnum::VariantB { inner: InnerStruct { field2: f2, .. }, .. } => *f2,
        }
    }

    fun test_variant_a(): u8 {
        let e = NestedEnum::VariantA(7, InnerStruct { field1: 8, field2: true });
        get_first_u8(&e)
    }

    fun test_variant_b(): u8 {
        let e = NestedEnum::VariantB { number: 9, inner: InnerStruct { field1: 10, field2: false } };
        get_first_u8(&e)
    }

    fun test_variant_b_second(): u8 {
        let e = NestedEnum::VariantB { number: 11, inner: InnerStruct { field1: 12, field2: true } };
        get_second_u8(&e)
    }

    fun test_variant_a_second(): u8 {
        let e = NestedEnum::VariantA(13, InnerStruct { field1: 14, field2: false });
        get_second_u8(&e)
    }
}

//# run --verbose -- 0x99::nested_enum::test_variant_a
//# run --verbose -- 0x99::nested_enum::test_variant_b
//# run --verbose -- 0x99::nested_enum::test_variant_b_second
//# run --verbose -- 0x99::nested_enum::test_variant_a_second

//# run
script {
fun main() {
    let x;
    if (false)
        x = 42
    else
        x = 100;
    x;
}
}
