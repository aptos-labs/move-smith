//# publish
module 0xCAFE::TestDeadCopy {
    // Structs with various abilities
    struct CopyDropStruct has copy, drop {
        value: u64,
    }

    struct StoreKeyStruct has store, key {
        data: vector<u8>,
    }

    // Function to test dead copy behavior inside conditionals
    public fun test_dead_copy_behavior() {
        let x = 42u64;
        let y = 84u64;
        let a: u64; // local variable to hold potential reassignments

        if (x > y) {
            a = x;
            // a is assigned, potential copy
            let _temp = a; // use a to simulate copy
            a = 1u64; // reassign
            // old 'a' copy is dead here
        } else {
            a = y;
            let _temp = a;
            a = 2u64;
        }
        // After branches, 'a' holds the last assigned value
        // The copy from previous branch should be considered dead
        // No assertions, just to exercise compiler/VM
    }

    // Function with parameter containing a function type
    // In Move, functions cannot directly be in types, but can be referenced via function pointers in scripts
    // For demonstration, define a function pointer type, then pass it as parameter
    public fun call_with_function_param(f: &fn()): {
        f();
    }

    // Function that returns a function pointer (simulate functions returning functions)
    public fun get_function_pointer(): &fn() {
        fun inner() {
            // empty function body
        }
        &inner
    }

    // Runner function to exercise function parameters and returns
    public fun run_function_examples() {
        let fp = get_function_pointer();
        call_with_function_param(fp);
    }
}

// //# publish
module 0xCAFE::AbilitiesDemo {
    // Struct with all abilities (copy, drop, store, key)
    struct FullAbilitiesStruct has copy, drop, store, key {
        data: u64,
    }

    // Struct with only store ability
    struct StoreOnlyStruct has store {
        data: vector<u8>,
    }

    // Struct with only copy and drop (no store, no key)
    struct CopyDropOnlyStruct has copy, drop {
        data: bool,
    }

    // Resource-like struct with key and store but not copy or drop
    struct ResourceType has store, key {
        id: u64,
        info: vector<u8>,
    }

    // Function to create instances of each type
    public fun create_structs() {
        let _full = FullAbilitiesStruct { data: 100 };
        let _store_only = StoreOnlyStruct { data: b"hello" };
        let _copy_drop_only = CopyDropOnlyStruct { data: true };
        let _resource = ResourceType { id: 1, info: b"resource_info" };
        // For resource, typically move_to would be used in a resource context,
        // but for test, we just instantiate
    }
}

// //# run 0xCAFE::TestDeadCopy::test_dead_copy_behavior --signers 0xCAFE
// //# run 0xCAFE::AbilitiesDemo::create_structs --signers 0xCAFE

// Featurres:
// 7bb0e1244ee99a0fceec8f4903df9c59: Test that dead copies of variables killed by reassignment inside conditional branches are not incorrectly considered live or available after the branch.
// 960f290e3dbdbd5e860ccd976e950750: Identify function parameters whose return type contains a function
// f48fcff461e75f17a86fe8704186a297: Annotate structs with abilities such as Copy, Drop, Store, and Key to control their usage and resource semantics in Move.
