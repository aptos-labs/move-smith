//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Reference addresses to ensure referencing correctness
    const ADDR1: address = 0xBADA55;
    const ADDR2: address = 0xCAFEBABE;

    struct TestStruct has store, key {
        id: u64,
        name: vector<u8>,
    }

    public fun create_test_struct(id: u64, name_str: u8): TestStruct {
        let name_vec = vector::empty<u8>();
        vector::push_back(&mut name_vec, name_str);
        TestStruct { id, name: name_vec }
    }

    public fun process_struct(s: &TestStruct, multiplier: u8): u8 {
        let name_len = vector::length(&s.name);
        let sum_name: u8 = if (name_len > 0) {
            let first_byte = *vector::borrow(&s.name, 0);
            first_byte * multiplier
        } else {
            0u8
        };
        sum_name
    }

    // Define the enum E properly
    enum E {
        V1,
        V2(a: u8, b: u8),
        V3 { a: bool },
    }

    public fun test_enum_branch(e: &E): u8 {
        match e {
            E::V1 => 1,
            E::V2(a, b) => a + b,
            E::V3 { a } => if (a) { 2 } else { 3 },
        }
    }

    // Define the generic struct as well
    struct StructWithTypeParameter<T> has store {
        field: T,
    }

    public fun test_generic_struct<T>(g: &StructWithTypeParameter<T>): u64
    where T: copy {
        42
    }

    public fun nested_function_with_loop(x: u8): u8 {
        let count = 0u8;
        let index = x;
        while (index < 10) {
            index = index + 1;
            count = count + 1;
        };
        count
    }

    public fun test_vector_operations() {
        let v: vector<u8> = vector::empty();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);

        let first = *vector::borrow(&v, 0);
        let second = *vector::borrow(&v, 1);

        assert!(first == 1u8, 0);
        assert!(second == 2u8, 0);
    }

    public fun test_conditionals_and_loop() {
        let x = 5u8;
        let y: u8;
        if (x > 3) {
            y = 10;
        } else {
            y = 20;
        }
        let count = 0u8;
        let num = y; // use mut to allow reassignment
        while (num > 0) {
            num = num - 1;
            count = count + 1;
        };
        count
    }
}

// Usage examples (commented out) -- these are not part of the module, but show how to call functions:

// # run 0xDEAD::TestModule::create_test_struct --args 123u64 65u8
// # run 0xDEAD::TestModule::process_struct --signers 0xBADA55 --args 123u64 65u8
// # run 0xDEAD::TestModule::test_enum_branch --args 'E::V2(10, 20)'
// # run 0xDEAD::TestModule::test_enum_branch --args 'E::V3 { a: true }'
// # run 0xDEAD::TestModule::test_enum_branch --args 'E::V3 { a: false }'
// # run 0xDEAD::TestModule::test_generic_struct --args 'StructWithTypeParameter { field: 42 }'
// # run 0xDEAD::TestModule::nested_function_with_loop --args 3u8
// # run 0xDEAD::TestModule::test_vector_operations
// # run 0xDEAD::TestModule::test_conditionals_and_loop
