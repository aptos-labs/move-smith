//# publish
module 0x1::counter {
    use std::assert;
    use std::signer;

    // Counter resource with value
    struct Counter has key {
        value: u64,
    }

    // Initialize the counter resource
    public fun init_counter(account: &signer) {
        move_to(account, Counter { value: 0 })
    }

    // Increment the counter
    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    // Get the current value
    public fun get_value(counter: &Counter): u64 {
        counter.value
    }

    // Runner function to test `while` loop counting
    public fun run_counter() {
        let counter_address = @0x1;
        // Let's assume the account has already initialized the counter
        let counter_ref = borrow_global_mut<Counter>(counter_address);
        let mut i = 0;
        while (i < 5) {
            increment(counter_ref);
            i = i + 1;
        }
        // Assert that the counter reached 5
        assert::assert(counter_ref.value == 5, 0);
    }
}

//# run 0x1::counter::run_counter

//# publish
module 0x2::applying_structs {
    use std::assert;
    use std::signer;

    // Example struct to apply
    struct MyStruct has copy, drop, store {
        field1: u64,
        field2: u8,
    }

    // Function that accepts a reference to MyStruct and performs addition
    public fun apply_struct_fields(s: &MyStruct, add_value: u64): u64 {
        s.field1 + add_value
    }

    // Runner function to test applying structs by name
    public fun run_apply_structs() {
        let s = MyStruct { field1: 10, field2: 20 };
        let result = apply_struct_fields(&s, 5);
        // The result should be 15
        assert::assert(result == 15, 1);
    }
}

//# run 0x2::applying_structs::run_apply_structs