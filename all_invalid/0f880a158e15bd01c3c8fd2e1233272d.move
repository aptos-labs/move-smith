
//# publish
module 0xBADA::Main {
    use 0xDEAD::InteractionTest;
    use std::signer;

    public fun perform_complex_test(s: &signer) {
        // Initialize AbilityHolder
        let abilities: vector<symbol> = vector::empty<symbol>();
        let holder = AbilityHolder { abilities };

        // Add abilities
        InteractionTest::add_ability_external(&mut holder, b"upload");
        InteractionTest::add_ability_external(&mut holder, b"download");

        // Shadowing variable inside loop
        let count = 0;
        while (count < 3) {
            let count_inner = count + 1; // shadowed variable
            // Use a different variable inside the loop to prevent shadowing of outer 'count'
            // The outer count remains unchanged
            assert!(count_inner <= 3, 108);
            count = count + 1; // increment outer variable explicitly if needed
        };
        // variable outside loop should remain unchanged
        assert!(count == 3, 109);

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
