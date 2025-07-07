
//# publish
module 0xCAFE::RefCopyTest {
    use std::signer;

    struct Counter has copy, drop {
        val: u64
    }

    // Store a Counter resource at the signer's address
    public fun store_counter(s: signer, initial: u64) {
        let counter = Counter { val: initial };
        move_to<Counter>(&s, counter);
    }

    // Increment the counter by creating multiple references and copying
    public fun increment_counter(s: signer) {
        let addr = signer::address_of(&s);
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(addr);
        counter_ref.val = counter_ref.val + 1;

        // Create second mutable reference (allowed because no aliasing here, but actually borrow_global_mut is unique)
        // So to simulate multiple references, let's create immutable references:
        let counter_ref1: &Counter = borrow_global<Counter>(addr);
        let counter_ref2: &Counter = counter_ref1;

        // Copy the value from counter_ref2
        let val_copy: u64 = counter_ref2.val;

        // The val_copy should equal counter_ref1.val and counter_ref.val
        // No asserts per instruction
    }

    // Function to demonstrate multiple immutable references and copy
    public fun multi_ref_copy(s: signer): u64 {
        let addr = signer::address_of(&s);
        let counter_ref1: &Counter = borrow_global<Counter>(addr);
        let counter_ref2: &Counter = counter_ref1;

        let val1 = counter_ref1.val;
        let val2 = counter_ref2.val;
        let val3 = val2;

        // Return sum of all to check behavior; (val1 + val2 + val3)
        val1 + val2 + val3
    }

    // Demonstrate struct with comma-separated abilities and use of Empty address constant
    const Empty: address = @0x0;

    struct Data has key, store, drop {
        id: u8,
        dummy: bool
    }

    public fun store_data_empty(s: signer, id: u8, dummy: bool) {
        let data = Data { id, dummy };
        move_to<Data>(&s, data);
    }
}


//# run 0xCAFE::RefCopyTest::store_counter --signers 0xB100 --args 10u64


//# run 0xCAFE::RefCopyTest::increment_counter --signers 0xB100


//# run 0xCAFE::RefCopyTest::multi_ref_copy --signers 0xB100


//# run 0xCAFE::RefCopyTest::store_data_empty --signers 0xB100 --args 42u8 true


// Featurres:
// 46fd4f6e867eb4a8b85640fbe5fdf1c4: Verify that multiple references to the same local variable correctly point to the same value and that copying and referencing behave as expected in assertions.
// 0c5e7fdec695e24e3a309ea0a7ec424a: Use address specifier 'Empty' to represent an unspecified or default address.
// c5a306a2c2b0597752c1920c84745b1c: Declare struct or resource abilities using the 'has' keyword followed by a comma-separated list of abilities in your Move module or script.
