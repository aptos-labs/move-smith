
//# publish
module 0xBADD::TypeCastingTest {
    use std::abort;
    use std::vector;

    // Helper function for safe casting from u128 to u8.
    public fun cast_u128_to_u8(val: u128): u8 acquires {
        if (val > 255) {
            abort 1;
        };
        val as u8
    }

    // Helper function for safe casting from u64 to u16.
    public fun cast_u64_to_u16(val: u64): u16 {
        if (val > 65535) {
            abort 2;
        };
        val as u16
    }

    // Helper function for safe casting from u32 to u8.
    public fun cast_u32_to_u8(val: u32): u8 {
        if (val > 255) {
            abort 3;
        };
        val as u8
    }

    // Helper function for safe casting from u16 to u8.
    public fun cast_u16_to_u8(val: u16): u8 {
        if (val > 255) {
            abort 4;
        };
        val as u8
    }

    // Struct with generic field
    struct GStruct<T> has copy, drop, store {
        value: T,
        marker: T,
    }

    // Definition of address block for organization
    address 0xDEAD {
        struct AddressScopedStruct<ValType> has store, drop {
            data: ValType,
        }

        public fun create_scoped_struct<ValType: copy + drop>(val: ValType): AddressScopedStruct<ValType> {
            AddressScopedStruct { data: val }
        }

        public fun get_data<ValType>(s: &AddressScopedStruct<ValType>): &ValType {
            &s.data
        }
    }

    // Function testing casting within range for all types
    public fun test_cast_in_range() {
        let _ = cast_u128_to_u8(255 as u128);
        let _ = cast_u64_to_u16(65535);
        let _ = cast_u32_to_u8(255);
        let _ = cast_u16_to_u8(255);
        let _ = cast_u128_to_u8(0);
        let _ = cast_u64_to_u16(0);
        let _ = cast_u32_to_u8(0);
        let _ = cast_u16_to_u8(0);
    }

    // Function testing casting overflow aborts
    public fun test_cast_overflow() {
        // These should abort
        let _ = cast_u128_to_u8(256 as u128);
        let _ = cast_u64_to_u16(70000);
        let _ = cast_u32_to_u8(300);
        let _ = cast_u16_to_u8(300);
    }

    // Function creating address scoped struct with type parameter
    public fun create_scoped<ValType: copy + drop>(val: ValType) {
        let scoped_struct = 0xDEAD::AddressScopedStruct<ValType>::create_scoped_struct(val);
        let data_ref = 0xDEAD::AddressScopedStruct<ValType>::get_data(&scoped_struct);
        // do something with data_ref, just load it to test access
        *data_ref
    }

    // Example instantiation of the generic struct with an in-range value
    public fun create_struct_with_type_param() {
        let g1 = GStruct<u64> { value: 12345, marker: 54321 };
        let g2 = GStruct<u128> { value: 2u128, marker: 3u128 };
    }
}


//# run 0xBADD::TypeCastingTest::test_cast_in_range

//# run 0xBADD::TypeCastingTest::test_cast_overflow

//# run 0xBADD::TypeCastingTest::create_scoped 123u64

//# run 0xBADD::TypeCastingTest::create_struct_with_type_param


// Featurres:
// 568449f26f659f790073bcafa319fa2e: Test that casting between unsigned integer types (u8, u16, u32, u64, u128, u256) in Move succeeds for in-range values and aborts for out-of-range (overflowing) values.
// 74681f36d6c736c72d34251500452355: Define address blocks to organize and scope modules under specific account addresses.
// fa09991c70ad2489dd408fee816518bc: Use type parameters in the types of struct fields.
