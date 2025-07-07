
//# publish
module 0xBABB::TestModule {
    use std::signer;

    // Struct with abilities and test-only functions for testing compiler and VM features
    struct TestStruct has copy, drop, store, key {
        a: u8,
        b: u16,
        c: bool,
    }

    // Enum with abilities and test-only functions
    enum TestEnum has copy, drop {
        Variant1,
        Variant2: u32,
        Variant3 { flag: bool },
    }

    // Function with `TestOnly` attribute to restrict to test environment
    public fun test_only_create_struct() acquires TestStruct {
        // Instantiate a struct with various abilities
        let s = TestStruct {a: 10u8, b: 100u16, c: true};
        s
    }

    public fun test_only_create_enum(): TestEnum {
        // Instantiate enum variant
        let e = TestEnum::Variant2;
        e
    }

    // Test function for casting and match expressions with enum
    public fun test_only_enum_match(e: TestEnum): u8 {
        let result = match (e) {
            TestEnum::Variant1 => 1,
            TestEnum::Variant2 => 2,
            TestEnum::Variant3 { flag } => if (flag) { 3 } else { 4 },
        };
        result
    }

    // Function testing nested expressions and ability in struct fields
    public fun test_only_nested_expressions() {
        let nested_value = if (true) {
            5u8 + 3u8
        } else {
            0u8
        };
        let _s = TestStruct {a: nested_value, b: 200u16, c: false};
    }

    // Function testing generic enum instantiation and copy abilities
    public fun test_only_generic_enum() {
        let e1 = TestEnum::V2;
        let e2 = TestEnum::V3 { flag: true };

        // Use enum in match
        match (e2) {
            TestEnum::V1 => 0,
            TestEnum::V2 => 1,
            TestEnum::V3 { flag } => if (flag) { 1 } else { 0 },
        }
    }

    // Function testing vector usage with different types
    public fun test_only_vector_usage() {
        let vec_u8 = vector::empty<u8>();
        vector::push_back(&mut vec_u8, 7);
        vector::push_back(&mut vec_u8, 8);
        let _ = vector::borrow(&vec_u8, 0);
        let _ = vector::pop_back(&mut vec_u8);

        let vec_bool = vector::empty<bool>();
        vector::push_back(&mut vec_bool, true);
        vector::push_back(&mut vec_bool, false);
        let _ = vector::borrow(&vec_bool, 1);
        let _ = vector::pop_back(&mut vec_bool);
    }

    // Function testing while and loop usage
    public fun test_only_looping() {
        let x = 0u8;
        while (x < 3) {
            x = x + 1;
        };
        loop {
            if (x == 0) {
                break;
            };
            x = x - 1;
        };
        x
    }

    // Function testing assertions
    public fun test_only_asserts() {
        assert!(true, 0);
        assert!(false, 999);
    }

    // Function using nested calls and functions with abilities
    public fun test_only_function_calls() {
        let val = test_only_create_struct();
        let enum_val = test_only_create_enum();
        test_only_enum_match(enum_val)
    }

    // Runner for all test functions
    public fun run_all_tests() {
        let _ = test_only_create_struct();
        let _ = test_only_create_enum();
        let _ = test_only_enum_match(TestEnum::V2);
        test_only_nested_expressions();
        test_only_generic_enum();
        test_only_vector_usage();
        test_only_looping();
        test_only_asserts();
        test_only_function_calls();
    }
}


//# run 0xBABB::TestModule::run_all_tests


// Featurres:
// c256dd28ed8031dd5970fbc31517ef53: Annotate test-only functions with the 'TestOnly' attribute to mark them as restricted to testing environments.
// 644ee5d5e5c15902cb72950195e26707: Optionally use specific Move language tokens in your code without requiring them in every context.
// c5a306a2c2b0597752c1920c84745b1c: Declare struct or resource abilities using the 'has' keyword followed by a comma-separated list of abilities in your Move module or script.
