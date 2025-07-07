
//# publish
module 0xCAFE::NativeLayout {
    use std::signer;

    native struct NativeStruct has key, store {
        id: u64,
        flag: bool,
    }

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
        // positional unpack with .. to ignore middle fields
        let ComplexStruct { a, b, .., e} = s;
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
}



// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
// 99e0c7dc69100368ea067e3fb522be33: Perform positional unpacking of struct or variant patterns with support for a single `..` to ignore remaining fields.
// 916e7988631e0eda4f4ef5f6ecc5844b: Attach specifications to a script for additional assertions or requirements.
