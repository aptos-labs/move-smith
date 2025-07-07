
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    struct NativeStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct SingletonStruct has key {
        value: u8,
    }

    enum VariantEnum has copy, drop {
        A,
        B(u8),
        C { x: u8, y: u8 }
    }

    // Moved MyModule outside of LambdaTest as its own module
}


//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }
}


//# publish
module 0xCAFE::LambdaTestExtras {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        assert!(sum >= x, 0); // sanity check no overflow for testing
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| { a + b };
        let sum = adder(x, y);
        sum
    }

    public fun call_inline_nested(a: u16, b: u16): u16 {
        let (r1, r2) = 0xCAFE::MyModule::f2(a);
        // combine values from nested calls
        (r1 + r2) + b
    }

    use std::signer;
    use 0xCAFE::LambdaTest::{NativeStruct, SingletonStruct, VariantEnum};
    use std::signer;
    use std::coin;

    public fun create_native_struct(x: u8, y: u8): NativeStruct {
        NativeStruct { a: x, b: y }
    }

    public fun create_singleton(s: signer, val: u8) {
        let obj = SingletonStruct { value: val };
        move_to<SingletonStruct>(&s, obj);
    }

    public fun read_singleton(s: signer): u8 acquires SingletonStruct {
        let obj_ref = borrow_global<SingletonStruct>(signer::address_of(&s));
        obj_ref.value
    }

    public fun create_variant_a(): VariantEnum {
        VariantEnum::A
    }

    public fun create_variant_b(val: u8): VariantEnum {
        VariantEnum::B(val)
    }

    public fun create_variant_c(x: u8, y: u8): VariantEnum {
        VariantEnum::C { x, y }
    }
}
