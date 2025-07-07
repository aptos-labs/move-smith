
//# publish
module 0xDEAD::InteractionTest {
    use std::vector;
    use std::signer;

    // Define a struct with abilities to test abilities management
    struct AbilityHolder has store, key {
        abilities: vector<symbol>,
    }

    // Internal function: should NOT be accessible outside this module
    fun internal_add_ability(holder: &mut AbilityHolder, ability: symbol) {
        if (vector::contains(&holder.abilities, &ability)) {
            // Do not add duplicate
        } else {
            vector::push_back(&mut holder.abilities, ability);
        }
    }

    // Public function that calls internal add ability
    public fun add_ability_external(holder: &mut AbilityHolder, ability: symbol) {
        internal_add_ability(holder, ability);
    }

    // Function that attempts to access internal functions externally (should fail if attempted)
    public fun attempt_internal_access() {
        // This function intentionally left blank; external code should NOT access `internal_add_ability`
        // ACK: No code here to test compile-time restriction
    }

    // Function to test variable scope inside and outside loops 
    public fun variable_scope_test() {
        let outside_var = 100;
        // Shadow variable inside while loop
        while (outside_var > 90) {
            let outside_var = outside_var - 1; // shadowed variable
            // inside loop, outside_var is local
            assert!(outside_var < 100, 101);
        };
        // post loop, outside_var should be unchanged
        assert!(outside_var == 100, 102);
    }

    // Function to test variable declaration with shadowing and persistence
    public fun nested_variable_shadowing() {
        let x = 5;
        let y = 10;
        // Shadow x with new local x inside block
        {
            let x = x + 1;
            // This x is local
            assert!(x == 6, 103);
        };
        // Outer x remains unchanged
        assert!(x == 5, 104);
        assert!(y == 10, 105);
    }

    // Function to test abilities addition with duplicates
    public fun abilities_management() {
        let abilities = vector::empty<symbol>();
        // Add abilities
        vector::push_back(&mut abilities, b"read");
        vector::push_back(&mut abilities, b"write");
        // Attempt to add duplicate
        if (vector::contains(&abilities, &b"read")) {
            // Do nothing
        } else {
            vector::push_back(&mut abilities, b"read");
        }
        // Now abilities should contain read and write only once
        assert!(vector::length(&abilities) == 2, 106);
        // Confirm no duplicates
        let count_read = 0;
        let i = 0;
        while (i < vector::length(&abilities)) {
            let ability = vector::borrow(&abilities, i);
            if (*ability == b"read") {
                count_read = count_read + 1;
            };
            i = i + 1;
        };
        assert!(count_read == 1, 107);
    }
}


//# run 0xDEAD::InteractionTest::variable_scope_test


//# run 0xDEAD::InteractionTest::nested_variable_shadowing


//# run 0xDEAD::InteractionTest::abilities_management


//# publish
module 0xFACE::ExternalAccess {
    use 0xDEAD::InteractionTest;

    // Function attempting to call internal add_ability directly (should fail compile if uncommented)
    // public fun external_invoke_internal(holder: &mut InteractionTest::AbilityHolder, ability: symbol) {
    //     InteractionTest::internal_add_ability(holder, ability); // Not accessible
    // }

    // Correctly calling public wrapper
    public fun add_ability_through_wrapper(holder: &mut InteractionTest::AbilityHolder, ability: symbol) {
        InteractionTest::add_ability_external(holder, ability);
    }
}


//# run 0xFACE::ExternalAccess::add_ability_through_wrapper --signers 0x123 --args ability=b"execute" 


//# publish
module 0xBADA::Main {
    use 0xDEAD::InteractionTest;
    use std::signer;

    public fun perform_complex_test(s: signer) {
        // Initialize AbilityHolder
        let abilities: vector<symbol> = vector::empty<symbol>();
        let holder = AbilityHolder { abilities };

        // Add abilities
        InteractionTest::add_ability_external(&mut holder, b"upload");
        InteractionTest::add_ability_external(&mut holder, b"download");

        // Shadowing variables inside loop
        let count = 0;
        while (count < 3) {
            let count = count + 1; // shadowed
            // isolate inside loop variable
            assert!(count <= 3, 108);
        };
        // variable outside loop should remain unchanged
        assert!(count == 0, 109);

        // Testing internal function access - should not be accessible directly by external modules
        // but we call the wrapper
        // Since internal_add_ability is not public, only wrapper can call
        InteractionTest::add_ability_external(&mut holder, b"execute");

        // Verify abilities have no duplicates: only unique entries
        let seen_abilities = vector::empty<symbol>();
        let i = 0;
        while (i < vector::length(&holder.abilities)) {
            let ability = vector::borrow(&holder.abilities, i);
            if (vector::contains(&seen_abilities, ability)) {
                // do nothing
            } else {
                vector::push_back(&mut seen_abilities, *ability);
            }
            i = i + 1;
        }

        // Final assertions: abilities contain uploaded, downloaded, execute at least
        assert!(vector::contains(&holder.abilities, &b"upload"), 110);
        assert!(vector::contains(&holder.abilities, &b"download"), 111);
        assert!(vector::contains(&holder.abilities, &b"execute"), 112);
    }
}


//# run 0xBADA::Main::perform_complex_test --signers 0x999


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// bf2871c72722f6a1aabf797ad94f3c13: Detect and report duplicate abilities when adding to an abilities set.
