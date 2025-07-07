// Remove all invalid 'use' statements for std::assert and std::vector
// Also, fix the module references to ensure they are correctly scoped and valid

//# publish
module 0xCAFE::TestGlobalAnalysis {
    // This module tests global analysis correctness by compiling complex features together
    public fun dummy() {}
}

//# publish
module 0xCAFE::TestParser {
    // Use assertion from the prelude (assert! macro is available globally in Move)
    // No need to 'use std::assert;'
    use std::vector;

    // Declare functions with binary expressions involving various operators

    public fun test_binary_expressions(): bool {
        let a: u64 = 10;
        let b: u64 = 20;
        let c: bool;

        // Equality and inequality
        assert!(a == 10, 1);
        assert!(b != 10, 2);
        // Comparisons
        assert!(a < b, 3);
        assert!(b > a, 4);
        // Bitwise operators (^, |, &)
        let xor = a ^ b;
        let or = a | b;
        let and = a & b;
        assert!(xor == (10 ^ 20), 5);
        assert!(or == (10 | 20), 6);
        assert!(and == (10 & 20), 7);
        // Shift operators (<<, >>)
        let shift_left = a << 2;
        let shift_right = b >> 1;
        assert!(shift_left == 40, 8);
        assert!(shift_right == 10, 9);
        // Arithmetic (+, -, *, /, %)
        assert!(a + b == 30, 10);
        assert!(b - a == 10, 11);
        assert!(a * 2 == 20, 12);
        assert!(b / 2 == 10, 13);
        assert!(b % 3 == 2, 14);
        // Range (..)
        let range_vec: vector<u64> = vector::empty();
        let _ = vector::push_back(&mut range_vec, a);
        let _ = vector::push_back(&mut range_vec, b);
        assert!(vector::length(&range_vec) == 2, 15);
        // Implication (==>) -- only allowed in specs
        // Note: move does not support '==>' in expression; these should be in specs
        // To avoid compile error, comment out or remove these lines or wrap in specs
        // but for the test code, we will just skip them
        // let imp = a < b ==> b > a;
        // assert!(imp, 16);
        // Equivalence (<==>) -- only allowed in specs
        // similarly, skipping implementation here
        // let equiv = (a + 0 == a) <==> (b - 0 == b);
        // assert!(equiv, 17);
        // For illustration, we'll skip the implication and equivalence checks as they
        // are only valid in specs context

        // combined complex expression
        c = ((a + b) > 15) && (a != b);
        assert!(c, 18);
        true
    }
}

//# publish
module 0xCAFE::TestInit {
    // use std::assert; // no need, assert! is globally available
    use 0xCAFE::MyModule;

    // Map keys to their lengths plus two and values with three added
    public fun test_initialize() acquires MyModule {
        // invoke init
        MyModule::initialize();
        let keys_length = MyModule::get_keys_length();
        let values_sum = MyModule::get_values_sum();

        // Assuming keys length is 3 (from test keys) plus 2 = 5
        assert!(keys_length == 5, 1);
        // Assuming values are each original value +3 (100+3 + 200+3 + 300+3 = 600)
        assert!(values_sum == ( (100 + 3) + 200 + 3 + 300 + 3 ), 2);
    }
}

//# publish
module 0xCAFE::MyModule {
    use std::vector;
    use std::table::{Self, Table}; // Unused? Remove if not used
    use std::signer;

    struct MyData has store, key {
        keys: vector<vector<u8>>,
        values: vector<u64>,
    }

    struct GlobalData has key {
        data: MyData,
        initialized: bool,
    }

    // Use a resource singleton pattern
    // Since static vars are not supported directly, manage via global resource
    // The 'global' option should be a global resource; in Move, typically use
    // an option stored in a global resource with an explicit account

    // We will adapt by making 'GlobalData' a resource stored at a specific address
    // in move, for example, at address 0xCAFE

    // For the purpose of this test, use 'GlobalData' as a resource stored at 0xCAFE

    public fun initialize() {
        if (!exists<GlobalData>(0xCAFE)) {
            let keys = vector::empty<vector<u8>>();
            let values = vector::empty<u64>();
            // inserting sample keys
            let _ = vector::push_back(&mut keys, b"key1");
            let _ = vector::push_back(&mut keys, b"key2");
            let _ = vector::push_back(&mut keys, b"key3");
            // inserting sample values
            let _ = vector::push_back(&mut values, 100);
            let _ = vector::push_back(&mut values, 200);
            let _ = vector::push_back(&mut values, 300);
            move_to(&signer::address_of(&signer::borrow_signer()), 0xCAFE, GlobalData {
                data: MyData { keys, values },
                initialized: true,
            });
        }
    }

    public fun get_keys_length(): u64 acquires GlobalData {
        let global_ref = borrow_global<GlobalData>(0xCAFE);
        vector::length(&global_ref.data.keys)
    }

    public fun get_values_sum(): u64 acquires GlobalData {
        let global_ref = borrow_global<GlobalData>(0xCAFE);
        let sum: u64 = 0;
        let len = vector::length(&global_ref.data.values);
        let i: u64 = 0;
        while (i < len) {
            let val = *vector::borrow(&global_ref.data.values, i);
            // move cumulative sum
            // cannot reassign sum in move, so declare mutable
            // fix: declare 'let sum = 0;' at start
            // but since move variables are immutable by default, need mutable
            // Let's declare 'mut' at start
            sum = sum + val;
            i = i + 1;
        }
        sum
    }
}

//# publish
module 0xCAFE::TestContractSpecViolations {
    // use std::assert; // no need
    public fun valid_contract(x: u64) {
        assert!(x > 50, 100);
    }

    public fun invalid_contract() {
        let x: u64 = 10;
        assert!(x > 50, 101);
    }
}

//# publish
module 0xCAFE::TestCrossModuleInteraction {
    use 0xCAFE::MyModule;

    public fun call_get_keys_length(): u64 {
        MyModule::get_keys_length()
    }
}
