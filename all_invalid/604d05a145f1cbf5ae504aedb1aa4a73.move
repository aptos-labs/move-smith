
//# publish
module 0xBADD::TestModule {
    use std::vector;

    // A basic struct to test creation and storage
    struct TestStruct has copy, drop, store, key {
        id: u64,
        name: vector<u8>,
    }

    // A generic struct to test type parameters
    struct GenericStruct<T> has copy, drop {
        value: T,
        label: vector<u8>,
    }

    // An enum to test pattern matching and variant creation
    enum TestEnum has copy, drop {
        Variant1,
        Variant2(u64, vector<u8>),
        Variant3 { active: bool },
    }

    // A function that creates and returns a struct
    public fun create_struct(id: u64, name_bytes: vector<u8>): TestStruct {
        let s = TestStruct { id, name: name_bytes };
        s
    }

    // A function that creates and returns a generic struct
    public fun create_generic_struct_u8<T>(value: T, label: vector<u8>): GenericStruct<T> {
        let g = GenericStruct { value, label };
        g
    }

    // A function that creates and returns an enum variant
    public fun create_enum_variant2(val: u64, data: vector<u8>): TestEnum {
        let e = TestEnum::Variant2(val, data);
        e
    }

    // A function testing match pattern on enum
    public fun match_enum(e: TestEnum): u64 {
        let result = match (e) {
            TestEnum::Variant1 => 0,
            TestEnum::Variant2(x, _) => x,
            TestEnum::Variant3 { active } => if (active) { 1 } else { 2 },
        };
        result
    }

    // A function demonstrating nested struct and enum usage
    public fun nested_usage(id: u64, name_bytes: vector<u8>, val: u64, active_flag: bool): u64 {
        let s = create_struct(id, name_bytes);
        let e = create_enum_variant2(val, b"data");
        let enum_result = match_enum(e);
        if (enum_result == 0) {
            s.id
        } else {
            s.id + enum_result
        }
    }

    // A function to test vector operations
    public fun vector_test() {
        let v: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);
        let first = *vector::borrow(&v, 0);
        let last = vector::pop_back(&mut v);
        assert!(first == 10, 999);
        assert!(last == 20, 999);
        // After pop, the vector should contain only one element
        let remaining = *vector::borrow(&v, 0);
        assert!(remaining == 10, 999);
    }

    // A function that tests various features together
    public fun comprehensive_test(): u64 {
        // Create struct
        let name = b"Name\0";
        let s = create_struct(42, name);
        // Create generic struct
        let g = create_generic_struct_u8(7u8, b"label");
        // Create enum variant
        let e = create_enum_variant2(99, b"abc");
        // Match on enum
        let val = match_enum(e);
        // Use nested usage
        let nested_result = nested_usage(s.id, s.name, val, true);
        // Vector test
        vector_test();
        // Return some combination
        nested_result
    }
}



//# run 0xBADD::TestModule::comprehensive_test --signers 0xC0FF
