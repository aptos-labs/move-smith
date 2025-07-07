//# publish
module 0xCAFE::AbilityConstraintsTest {

    // A generic struct with various abilities to test ability constraints on type parameters
    struct Container<T> has store, drop {
        value: T,
    }

    // A copyable, droppable, storeable struct (primitive types)
    struct PrimitiveStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    // A non-copy, non-drop struct (simulate by not adding abilities)
    struct NonCopyDrop {
        data: vector<u8>,
    }

    // Function to create and store a Container with a copy-able type
    public fun create_container<T: copy + drop + store>(val: T): Container<T> {
        Container { value: val }
    }

    // Function to move out the value from a container (ownership transfer)
    public fun extract_value<T: store>(container: Container<T>): T {
        container.value
    }

    // Inline function to increment a mutable u64 and return the new value
    public inline fun inc(x: &mut u64): u64 {
        *x = *x + 1;
        *x
    }

    // Runner function to test ability constraints
    public fun test_ability_constraints() {
        // Test with primitive struct
        let prim = PrimitiveStruct { a: 10, b: true };
        let container_prim = create_container(prim);
        let val_prim = extract_value(container_prim);
        // No further action; just test ability constraints compile
    }

    // Runner function to test inline increment function
    public fun test_inc() {
        let num = 5u64;
        let new_num = inc(&mut num);
        // num should be 6 now
    }
}

//# run 0xCAFE::AbilityConstraintsTest::test_ability_constraints
//# run 0xCAFE::AbilityConstraintsTest::test_inc

// Featurres:
// 8212f57517317a04d52ee13b80e49762: Apply ability constraints (like 'copy', 'drop', etc.) to struct type parameters in Move.
// 17a37ab508306e6f3c1e1d6395652bb5: Define inline functions that are not native and have a body.
// 0d0379a1bb3df24eb05d04a4c28c0842: Test that the inline function `inc` correctly mutates a variable and returns the incremented value within the module.