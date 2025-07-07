//# publish
module 0xabcde::copy_move_tests {
    fun consume_u8(_x: u8) {}

    public fun test_u8(val: u8) {
        let copied_val = copy val;
        let moved_val = move copied_val;
        consume_u8(moved_val);
        consume_u8(val);
    }

    struct MyStruct has copy, drop {
        field1: u8,
        field2: u8,
    }

    fun consume_struct(_s: MyStruct) {}

    public fun test_struct(val: MyStruct) {
        let copied_struct = copy val;
        let moved_struct = move copied_struct;
        consume_struct(moved_struct);
        consume_struct(val);
    }

    // Additional test: moving structs with nested copy fields
    struct NestedStruct has copy, drop {
        inner: MyStruct,
        number: u64,
    }

    public fun test_nested_struct(val: NestedStruct) {
        let copied_nested = copy val;
        let moved_nested = move copied_nested;
        consume_struct(moved_nested.inner);
        // move nested number
        let number_value = move moved_nested.number;
        // We could process number_value if needed
        // Validate that original val is still usable
        assert!((val.inner.field1 == 0), 0); // Just a dummy assertion, actual verification may vary
    }

    public fun main() {
        // Test with primitive
        test_u8(255);
        // Test with struct
        test_struct(MyStruct { field1: 10, field2: 20 });
        // Test nested struct
        test_nested_struct(NestedStruct { inner: MyStruct { field1: 1, field2: 2 }, number: 42 });
    }
}

//# run 0xabcde::copy_move_tests::main