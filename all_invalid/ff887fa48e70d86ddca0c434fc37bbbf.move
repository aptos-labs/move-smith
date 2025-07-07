
//# publish
module 0xCAFE::ComprehensiveTest {
    // Use std for assertions and vector capabilities
    use std::assert;
    use std::vector;

    // 1. Define a complex nested struct to test unpacking and destructuring
    struct NestedStruct has copy, drop, store {
        id: u64,
        name: vector<u8>,
        inner: InnerStruct,
        flag: bool,
    }

    struct InnerStruct has copy, drop, store {
        value: u32,
        description: vector<u8>,
    }

    // 2. Functions to test parser behavior with complex expressions
    public fun binary_expression_tests(): bool {
        let a: u8 = 10;
        let b: u8 = 20;
        let c: bool = false;
        let d: bool = true;

        // Test == and !=
        assert!((a == 10u8), 1);
        assert!((b != 10u8), 2);

        // Test <, >, <=, >=
        assert!((a < b), 3);
        assert!((b > a), 4);
        assert!((a <= 10u8), 5);
        assert!((b >= 20u8), 6);

        // Test logical || and &&
        assert!((c || d), 7);
        assert!((c && d), 8);

        // Test bitwise XOR (^), OR (|), AND (&)
        let e: u8 = a ^ b;
        let f: u8 = a | b;
        let g: u8 = a & b;

        assert!((e == (a ^ b)), 9);
        assert!((f == (a | b)), 10);
        assert!((g == (a & b)), 11);

        // Test shift operators <<, >>
        let h: u8 = a << 2;
        let i: u8 = b >> 1;

        assert!((h == (a << 2)), 12);
        assert!((i == (b >> 1)), 13);

        // Test arithmetic +, -, *, /, %
        let j: u16 = 100 + 50;
        let k: u16 = 100 - 50;
        let l: u16 = 10 * 3;
        let m: u16 = 100 / 4;
        let n: u16 = 100 % 45;

        assert!((j == 150u16), 14);
        assert!((k == 50u16), 15);
        assert!((l == 30u16), 16);
        assert!((m == 25u16), 17);
        assert!((n == 10u16), 18);

        // Test range .. and ..<
        let range1: vector<u8> = vector::empty();
        let range2: vector<u8> = vector::range(0u8..5u8);
        // Fix: replace ..= with appropriate syntax
        // Move `..=5u8` to `vector::range_inclusive(0u8, 5u8)` if supported, or use alternative
        // Since Move currently doesn't support `..=` syntax directly, use vector::range_inclusive if available
        // Alternatively: replace with `vector::range_inclusive(start, end)` if such function exists,
        // but since standard Move may not have that, emulate inclusive range
        // For the purpose of this test, we'll define the inclusive range manually
        let range3: vector<u8> = /* no direct inclusive range; simulate how to get it */;
        // Since no `vector::range_inclusive`, we'll build it manually
        // For simplicity, remove the invalid line or define it, but in test code, we'll avoid the invalid syntax
        // Therefore, removing the line:
        // let range3: vector<u8> = vector::range(0u8..=5u8);
        //
        // Instead, create range3 via manual push:
        let range3: vector<u8> = vector::empty();
        let val: u8 = 0;
        while (val <= 5u8) {
            vector::push_back(&mut range3, val);
            val = val + 1;
        };

        let range4: vector<u8> = vector::range(5u8..<10u8);

        // Validate some range elements
        assert!(*vector::borrow(&range2, 0) == 0u8, 19);
        assert!(*vector::borrow(&range3, 5), 20);
        assert!(*vector::borrow(&range4, 0) == 5u8, 21);

        // Test arrow => in expressions
        let result = if (a > 5u8) { 1 } else { 0 };
        assert!((result == 1), 22);

        // Test less complex logical combinations
        let complex_expr = ((a < b) && (d || c)) || (a == 10u8);
        assert!((complex_expr == true), 23);

        true
    }

    // 3. Initialize function to manipulate KEYS and VALUES
    static KEYS: vector<u8> = vector::empty();
    static VALUES: vector<u8> = vector::empty();

    public fun init(): bool {
        // Populate KEYS with some bytes
        vector::push_back(&mut KEYS, 1u8);
        vector::push_back(&mut KEYS, 2u8);
        vector::push_back(&mut KEYS, 3u8);
        // For each key, add length + 2 to length_values list
        let len_keys = vector::length(&KEYS);
        let length_values: vector<u8> = vector::empty();
        let idx = 0;
        while (idx < len_keys) {
            let key: u8 = *vector::borrow(&KEYS, idx);
            vector::push_back(&mut length_values, key + 2);
            idx = idx + 1;
        };

        // Populate VALUES
        vector::push_back(&mut VALUES, 10u8);
        vector::push_back(&mut VALUES, 20u8);
        vector::push_back(&mut VALUES, 30u8);

        // Increment each element by 3
        let len_vals = vector::length(&VALUES);
        let i = 0;
        while (i < len_vals) {
            let val: u8 = *vector::borrow(&VALUES, i);
            let updated_val = val + 3;
            // swap: replace value at i with updated_v
            let _old = vector::swap(&mut VALUES, i, updated_val);
            i = i + 1;
        };
        // Assert correctness
        assert!(*vector::borrow(&VALUES, 0) == 13u8, 24);
        assert!(*vector::borrow(&VALUES, 1) == 23u8, 25);
        assert!(*vector::borrow(&VALUES, 2) == 33u8, 26);

        // Verify length of KEYS + 2
        assert!((vector::length(&KEYS) + 2 == 5), 27);
        // Values are incremented
        true
    }

    // 4. Testing copying values with Copy ability
    public fun copy_value_test(): (u64, u8) {
        let a: u64 = 123;
        let b: u8 = 45;

        // Copy a and b
        let a_copy = a;
        let b_copy = b;

        // Verify copied values are same
        assert!((a_copy == 123u64), 28);
        assert!((b_copy == 45u8), 29);

        (a_copy, b_copy)
    }

    // 5. Specification block with an 'axiom' ending with semicolon
    // verification(axiom)]
    public fun example_axiom() {
        // An example specification clause
        // (Assuming verification annotations are used; actual verification logic is external)
        // For semantic correctness, ensure assertion ends with a semicolon
        assert!(true, 30);
    }

    // 6. Test functions with // verification(...)] attributes
    // verification(my_verification_tag)]
    public fun verified_function(x: u8): u8 {
        x + 1
    }

    // Runner function to execute all above tests
    public fun run_all(): bool {
        // Call previous test functions
        assert!(binary_expression_tests(), 31);
        assert!(init(), 32);
        let (_a, _b) = copy_value_test();
        example_axiom();
        let _ = verified_function(5u8);
        true
    }
}



//# run 0xCAFE::ComprehensiveTest::run_all --signers 0xBADD --args
