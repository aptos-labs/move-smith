
//# publish
module 0xCAFE::NativeLayoutExample {
    use std::signer;

    // Native layout struct with fixed field types and key ability
    struct NativeStruct has key, store {
        a: u64,
        b: vector<u8>,
        c: bool,
    }

    // Store a native layout struct at signer address
    public fun store_native_struct(s: signer, a: u64, b: vector<u8>, c: bool) {
        let obj = NativeStruct {a, b, c};
        move_to<NativeStruct>(&s, obj);
    }

    // Borrow a reference to the native struct stored at signer address
    public fun borrow_native_struct(s: signer): &NativeStruct {
        borrow_global<NativeStruct>(signer::address_of(&s))
    }

    // Modify the native struct by changing fields
    public fun modify_native_struct(s: signer, new_a: u64, new_c: bool) {
        let obj_mut = borrow_global_mut<NativeStruct>(signer::address_of(&s));
        obj_mut.a = new_a;
        obj_mut.c = new_c;
    }

    // Remove the native struct from storage
    public fun remove_native_struct(s: signer) {
        let obj = move_from<NativeStruct>(signer::address_of(&s));
        let NativeStruct {a: _a, b: _b, c: _c} = obj;
    }
}


//# run 0xCAFE::NativeLayoutExample::store_native_struct --signers 0xBEEFBEEF --args 123u64 b"abc" true


//# run 0xCAFE::NativeLayoutExample::borrow_native_struct --signers 0xBEEFBEEF


//# run 0xCAFE::NativeLayoutExample::modify_native_struct --signers 0xBEEFBEEF --args 456u64 false


//# run 0xCAFE::NativeLayoutExample::borrow_native_struct --signers 0xBEEFBEEF


//# run 0xCAFE::NativeLayoutExample::remove_native_struct --signers 0xBEEFBEEF



//# publish
module 0xCAFE::ComprehensiveTargetTest {
    use std::signer;
    use std::vector;

    // Simple key struct for storage
    struct KeyStruct has key, store {
        id: u8
    }

    // Struct with generic type parameter and store ability
    struct GenericStruct<T> has store {
        name: vector<u8>,
        data: T,
    }

    // Enum with multiple variants for testing
    enum TestEnum has copy, drop {
        None,
        Single(u8),
        Complex { flag: bool, value: u64 },
    }

    // Store a KeyStruct instance at signer address
    public fun store_key_struct(s: signer, id: u8) {
        let ks = KeyStruct {id};
        move_to<KeyStruct>(&s, ks);
    }

    // Update the KeyStruct instance id field
    public fun update_key_struct(s: signer, new_id: u8) {
        let ks_mut = borrow_global_mut<KeyStruct>(signer::address_of(&s));
        ks_mut.id = new_id;
    }

    // Remove the KeyStruct instance from storage
    public fun remove_key_struct(s: signer) {
        let ks = move_from<KeyStruct>(signer::address_of(&s));
        let KeyStruct {id: _} = ks;
    }

    // Create and return a GenericStruct<u64> with given data
    public fun create_generic_struct_u64(val: u64): GenericStruct<u64> {
        GenericStruct<u64> {
            name: b"GenericU64",
            data: val,
        }
    }

    // Match on enum variants and return u64 accordingly
    public fun match_enum(e: TestEnum): u64 {
        match (e) {
            TestEnum::None => 0,
            TestEnum::Single(x) => x as u64,
            TestEnum::Complex { flag, value } => {
                if (flag) {
                    value
                } else {
                    0u64
                }
            }
        }
    }

    // Runner function that exercises key storage and enum matching
    public fun comprehensive_runner(s: signer) {
        store_key_struct(s, 42);
        update_key_struct(s, 84);
        let gen = create_generic_struct_u64(999u64);
        let res1 = match_enum(TestEnum::None);
        let res2 = match_enum(TestEnum::Single(10u8));
        let res3 = match_enum(TestEnum::Complex { flag: true, value: 123456u64 });
        remove_key_struct(s);
    }
}


//# run 0xCAFE::ComprehensiveTargetTest::store_key_struct --signers 0xAA11 --args 5u8


//# run 0xCAFE::ComprehensiveTargetTest::update_key_struct --signers 0xAA11 --args 10u8


//# run 0xCAFE::ComprehensiveTargetTest::remove_key_struct --signers 0xAA11


//# run 0xCAFE::ComprehensiveTargetTest::create_generic_struct_u64 --args 1000u64


//# run 0xCAFE::ComprehensiveTargetTest::match_enum --args TestEnum::None


//# run 0xCAFE::ComprehensiveTargetTest::match_enum --args TestEnum::Single(7u8)


//# run 0xCAFE::ComprehensiveTargetTest::match_enum --args TestEnum::Complex { flag: true, value: 9999u64 }


//# run 0xCAFE::ComprehensiveTargetTest::comprehensive_runner --signers 0xAA11


// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
