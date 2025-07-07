
//# publish
module 0xBEEFA::TestModule {
    use std::vector;

    // Dummy struct to simulate a scenario with unnecessary 'Self.' references which should be removed
    struct TestStruct has copy, drop, store {
        a: u8,
        b: u8
    }

    // Function to remove unnecessary 'Self.' references and test reference safety rules
    public fun clean_references_and_test(s: &signer): bool acquires TestStruct {
        let struct_ref: &TestStruct = borrow_global<TestStruct>(signer::address_of(s));
        let a_ref: &u8 = &struct_ref.a;
        let b_ref: &u8 = &struct_ref.b;

        // Use references, ensuring no cyclic or invalid reference use
        assert!(*a_ref == 1, 999);
        assert!(*b_ref == 2, 999);

        // Attempt to create a second mutable borrow - should fail if safety rules enforced
        // But for test, just do a correct mutable borrow flow
        let struct_mut_ref: &mut TestStruct = borrow_global_mut<TestStruct>(signer::address_of(s));
        struct_mut_ref.a = 10;
        struct_mut_ref.b = 20;

        // Using references after mutation
        let a_after: &u8 = &struct_mut_ref.a;
        let b_after: &u8 = &struct_mut_ref.b;

        // Use unbound_names_assigns for a list of references (simulate reverse processing)
        let lhs_list: vector<&mut u8> = vector::empty();
        vector::push_back(&mut lhs_list, &mut struct_mut_ref.a);
        vector::push_back(&mut lhs_list, &mut struct_mut_ref.b);

        // Now process in reverse order: process last first, then first for unbound names
        let _ = vector::pop_back(&mut lhs_list);
        let _ = vector::pop_back(&mut lhs_list);
        // process in order and check values
        assert!(*a_after == 10, 999);
        assert!(*b_after == 20, 999);

        // Final assertion to verify correctness
        *a_after == 10 && *b_after == 20
    }

    // Runner function to execute the test
    public fun run_test(s: &signer): bool {
        clean_references_and_test(s)
    }
}


//# run 0xBEEFA::TestModule::run_test --signers 0xABCDEF


// Featurres:
// 91ef0faeb00e239e5e3b19a1db582516: Remove unnecessary 'Self.' references from Move code.
// 264e8d0df05ecc5243ec3f8eecb914f0: Enforce reference safety rules for Move references.
// a04e6d039e207900b9d63688485d79f4: Use `unbound_names_assigns` to process a list of left-hand side expressions (`LValueList`) in reverse order for unbound name tracking.
