//# publish
module 0x1::test_module {
    use std::debug;

    // Example enum with nested structures
    enum MyEnum<phantom T> { 
        Variant1 { field1: u8, nested: NestedStruct },
        Variant2
    }

    // Nested struct for extracting u8 fields
    struct NestedStruct {
        nested_field: u8,
        other_field: u8,
    }

    // Function to extract specific u8 from nested structure
    fun extract_field1(nested: &NestedStruct): u8 {
        nested.nested_field
    }

    // Function that calls other functions respecting visibility
    fun inline_function() {
        // call a private function
        private_helper();
    }

    fun private_helper() {
        // do something
        debug::print(&"Helper function called");
    }

    // Function using update expressions within spec
    fun update_state(state: &mut u64, delta: u64) {
        *state = *state + delta;
    }

    // Function to create hex byte string
    fun create_hex_bytes(): vector<u8> {
        // Hex byte string with 'x""' prefix conceptually
        vec![0x12, 0x34, 0xAB]
    }

    // Function that computes sum of three predefined numbers
    fun for_user(): u64 {
        for i in 1..=3 {
            for(i in 1..=3) {
                // Simple loop summing numbers
            }
        }
        6 // return sum, for example
    }

    // A test function demonstrating nested if-continue with loop break
    // test]
    public fun test_nested_loop() {
        let sum = 0;
        let limit = 5;

        loop {
            if sum >= limit {
                break;
            }
            if sum % 2 == 0 {
                sum = sum + 1;
                continue;
            }
            sum = sum + 1;
        }

        assert!(sum >= limit, 0);
    }

    // A test to verify extraction from enum
    // test]
    public fun test_enum_extract() {
        let nested = NestedStruct { nested_field: 42, other_field: 99 };
        let variant = MyEnum::Variant1 { field1: 1, nested };
        // simulate extraction
        let field_value = match &variant {
            MyEnum::Variant1 { nested: n, .. } => extract_field1(n),
            _ => 0,
        };
        assert!(field_value == 42, field_value);
    }

    // A test to verify function call and update
    // test]
    public fun test_update() {
        let state: u64 = 10;
        update_state(&mut state, 5);
        assert!(state == 15, state);
    }

    // A test for create_hex_bytes function
    // test]
    public fun test_create_hex() {
        let bytes = create_hex_bytes();
        assert!(vector::length(&bytes) == 3, vector::length(&bytes));
        assert!(vector::borrow(&bytes, 0) == 0x12, vector::borrow(&bytes, 0));
    }

    // A test that confirms for_user sums correctly
    // test]
    public fun test_for_user_sum() {
        let total = for_user();
        assert!(total == 6, total);
    }
}
