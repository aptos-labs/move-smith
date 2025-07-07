
//# publish
module 0xDEAD::ASTLintTest {
    use std::vector;

    struct TestStruct has copy, drop, store, key {
        a: u8,
        b: u32,
    }

    enum TestEnum has copy, drop {
        Variant1,
        Variant2(u8, u16),
        Variant3 { flag: bool }
    }

    public fun check_struct_abilities(s: TestStruct) {
        // Confirm abilities adherence by using the struct
        let _copy_s = copy s;
        let _drop_s = s;
    }

    public fun check_enum_variant() {
        let e1 = TestEnum::Variant1;
        let e2 = TestEnum::Variant2(1, 2);
        let e3 = TestEnum::Variant3 { flag: true };
        // pattern match for enum variants
        let result = match e2 {
            TestEnum::Variant1 => 0,
            TestEnum::Variant2(val1, val2) => val1 + (val2 as u8),
            TestEnum::Variant3 { flag } => if flag { 1 } else { 0 },
        };
        assert!(result <= 255, 999);
        let _ = e3;
    }

    public fun apply_model_ast_checks() {
        // Call functions that implicitly test annotations and model conformance
        check_struct_abilities(TestStruct { a: 1, b: 42 });
        check_enum_variant();
    }

    // Additional function to test vector and abilities
    public fun test_vector_and_abilities() {
        let vec_u8: vector<u8> = vector::empty();
        vector::push_back(&mut vec_u8, 1);
        vector::push_back(&mut vec_u8, 2);
        vector::push_back(&mut vec_u8, 3);
        assert!(*vector::borrow(&vec_u8, 0) == 1, 42);
        assert!(*vector::borrow(&vec_u8, 2) == 3, 42);
        // Test move semantics with copy abilities
        let _copied_vec = copy vec_u8;
        let _reused_vec = vec_u8;
    }
}


//# run 0xDEAD::ASTLintTest::apply_model_ast_checks


// Featurres:
// 649533cb9c7559bb985c95ba8ec28fa9: Apply model AST lint checks for conformance to best practices
// aacd56972f7e4e045bc5c19edbe18a00: Resolve and import modules with named address prefixes, provided the mapping for the address exists in your project configuration.
// c0e5f1c148842980e7b90e85dc8b4add: Declare struct or resource types with the abilities: Copy, Drop, Store, and Key by using the respective ability names in Move code.
