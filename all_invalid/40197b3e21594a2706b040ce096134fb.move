// Corrected Move test code
//# publish
module 0x1::TestModule {
    use std::assert;

    // Example struct with abilities
    struct MyStruct has copy, drop, store {
        value: u64,
    }

    public fun test_example() {
        // Create a new instance of MyStruct
        let s = MyStruct { value: 42 };

        // Access nested fields using dot notation
        let val = s.value;

        // Assert the value
        assert::pay_eq(val, 42, 0);
        
        // Mutate the value (note: structs are immutable here, so need to reassign)
        let s = MyStruct { value: val + 1 };

        // Verify updated value
        assert::pay_eq(s.value, 43, 0);

        // Using vectors (if needed)
        let vec = vector::empty<u64>();
        vector::push_back(&mut vec, s.value);
        // Access via index
        let first_element = *vector::borrow(&vec, 0);
        assert::pay_eq(first_element, 43, 0);
    }
}
