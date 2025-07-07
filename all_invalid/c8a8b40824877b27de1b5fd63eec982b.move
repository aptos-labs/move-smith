
//# publish
module 0xCAFE::NativeLayout {
    use std::signer;
    use std::move_from;
    use std::move_to;
    use std::borrow_global;

    native struct NativeStruct has key, store;

    public fun create_native_struct(s: signer, id: u64, flag: bool) {
        let native_obj = NativeStruct { id, flag };
        move_to<NativeStruct>(&s, native_obj);
    }

    public fun read_native_struct(s: signer): (u64, bool) {
        let native_ref = borrow_global<NativeStruct>(signer::address_of(&s));
        (native_ref.id, native_ref.flag)
    }

    public fun delete_native_struct(s: signer) {
        let native_obj = move_from<NativeStruct>(signer::address_of(&s));
        let NativeStruct { id: _id, flag: _flag } = native_obj;
    }
}



//# run 0xCAFE::NativeLayout::create_native_struct --signers 0xBA5E --args 42u64 true



//# run 0xCAFE::NativeLayout::read_native_struct --signers 0xBA5E



//# run 0xCAFE::NativeLayout::delete_native_struct --signers 0xBA5E



//# publish
module 0xCAFE::PatternTest {
    struct ComplexStruct has copy, drop {
        a: u8,
        b: u8,
        c: u8,
        d: u8,
        e: u8,
    }

    enum ComplexEnum has copy, drop {
        Variant1,
        Variant2(u8, u8, u8, u8, u8),
        Variant3 { x: u8, y: u8, z: u8 },
    }

    public fun pattern_struct_unpack(s: ComplexStruct) {
        // positional unpack with .. must have .. at the end in named fields, 
        // so rewrite destructure to ignore middle by listing all but using underscore for ignored ones.
        let ComplexStruct { a, b, c: _, d: _, e } = s;
        // no-op, just unpacking to test positional unpacking with ..
        let _ = a + b + e;
    }

    public fun pattern_enum_unpack(e: ComplexEnum) {
        match (e) {
            ComplexEnum::Variant2(x, y, ..) => {
                let _z = x + y;
            },
            ComplexEnum::Variant3 { x, .. } => {
                let _ = x;
            },
            _ => {},
        };
    }
}



//# run 0xCAFE::PatternTest::pattern_struct_unpack --args 0x1u8 0x2u8 0x3u8 0x4u8 0x5u8



//# run 0xCAFE::PatternTest::pattern_enum_unpack --args 1u8 2u8 3u8 4u8 5u8


use 0xCAFE::NativeLayout;
use 0xCAFE::PatternTest;
use std::signer;

// Script specifications - just dummy specs to test spec attachment
spec script {
    requires true;
    ensures true;
    aborts_if false;
}

fun main() {
    // Create native struct at signer address 0xDEAD
    let addr = @0xDEAD;
    NativeLayout::create_native_struct(signer::borrow(addr), 123u64, true);
    // Read native struct values
    let (_id, _flag) = NativeLayout::read_native_struct(signer::borrow(addr));
    
    // Prepare complex struct for unpacking test
    let complex = PatternTest::ComplexStruct { a: 10u8, b: 20u8, c: 30u8, d: 40u8, e: 50u8 };
    PatternTest::pattern_struct_unpack(complex);

    // Prepare complex enum variant for unpacking test
    let variant2 = PatternTest::ComplexEnum::Variant2(5u8, 6u8, 7u8, 8u8, 9u8);
    PatternTest::pattern_enum_unpack(variant2);

    let variant3 = PatternTest::ComplexEnum::Variant3 { x: 99u8, y: 100u8, z: 101u8 };
    PatternTest::pattern_enum_unpack(variant3);
}
