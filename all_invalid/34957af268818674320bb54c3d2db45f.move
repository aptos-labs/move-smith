// #publish
module 0xCAFE::MultiTypeAndImportTest {
    use std::vector::{empty, push_back};
    use std::signer;

    // A simple copyable struct with key and store abilities
    struct Container<T1, T2> has store, copy, drop, key {
        item1: T1,
        item2: T2,
    }

    // Create a new Container with given two items
    public fun new_container<T1, T2>(item1: T1, item2: T2): Container<T1, T2> {
        Container { item1, item2 }
    }

    // A function to swap the two fields in Container if T1 and T2 are same types (test mutable reference and assignment in nested block)
    public fun swap_if_same<T>(c: &mut Container<T, T>) {
        // Nested block with mutable ref to Container and swap
        {
            let temp = copy c.item1;
            c.item1 = copy c.item2;
            c.item2 = temp;
        }
    }

    // A runner function that demonstrates these features
    public fun runner() {
        // Create a mutable Container<u64, u64>
        let mut cont = new_container(1u64, 2u64);
        // Create a mutable reference to cont
        let c_ref = &mut cont;

        // Use nested block and mutable reference to swap items
        {
            // Inside nested block, call swap_if_same on mutable reference
            swap_if_same(c_ref);
        }

        // Now cont.item1 should be 2 and cont.item2 should be 1
        // To test multiple type arguments, let's create another Container with different types
        let _cont_mixed = new_container(true, 42u8);
        // We do nothing with _cont_mixed, just create it to ensure generic expansion
    }
}
// #run 0xCAFE::MultiTypeAndImportTest::runner


// #publish
module 0xCAFE::TestImportAndNestedMutRef {
    // Import some named members explicitly from a module
    use 0xCAFE::MultiTypeAndImportTest::{Container, swap_if_same, new_container};

    // Another container struct to test import of structs explicitly, with different names inside this module
    struct MyPair<T> has store, drop, copy, key {
        a: T,
        b: T,
    }

    // Initialize and swap using the imported swap_if_same function
    public fun test_swap() {
        let mut cont = new_container(100u64, 200u64);
        let c_ref = &mut cont;
        swap_if_same(c_ref);

        // Also test using MyPair and swap values internally with nested block and mutation
        let mut pair = MyPair { a: 300u64, b: 400u64 };
        {
            let temp = pair.a;
            pair.a = pair.b;
            pair.b = temp;
        }
    }

    // A function that takes 3 type arguments and returns their triple as a tuple (test multiple type arguments)
    public fun triple_generic<T1, T2, T3>(x: T1, y: T2, z: T3): (T1, T2, T3) {
        (x, y, z)
    }

    public fun runner() {
        test_swap();

        let _triple = triple_generic(1u8, false, 123456u64);
    }
}
// #run 0xCAFE::TestImportAndNestedMutRef::runner


// #run
script {
    use 0xCAFE::MultiTypeAndImportTest::{new_container, swap_if_same};

    fun main() {
        // Create a Container<u8, u8> and swap using mutable reference and nested block
        let mut cont = new_container(10u8, 20u8);
        let c_ref = &mut cont;
        swap_if_same(c_ref);

        // Demonstrate nested block mutable reference assignments inline
        {
            let temp = c_ref.item1;
            c_ref.item1 = c_ref.item2;
            c_ref.item2 = temp;
        }
    }
}

// Featurres:
// f4128519df48a9f4fd3c1412821dbbeb: Import specific module members (such as structs or functions) using 'use Module::{Member1, Member2}'.
// e107718a80b4b87e9076b2d2081b8129: Test that mutable references and assignments work correctly within nested block expressions in Move.
// d870a0000b48e35cc77bca89dc41a92a: Write functions that take multiple type arguments and have them properly expanded in the compiler
