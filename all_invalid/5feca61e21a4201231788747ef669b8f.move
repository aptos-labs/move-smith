
//# publish
module 0xCAFE::AbilityTest {
    use std::vector;

    // Define abilities for testing
    struct AbilitySet has copy, drop, store {
        abilities: vector<string>,
    }

    // Function to create an ability set with specific abilities
    public fun create_ability_set(): AbilitySet {
        let abilities_vec = vector::empty<string>();
        // Corrected string literals by adding b prefix for byte strings
        vector::push_back(&mut abilities_vec, b"copy");
        vector::push_back(&mut abilities_vec, b"drop");
        vector::push_back(&mut abilities_vec, b"store");
        AbilitySet { abilities: abilities_vec }
    }

    // Function to check abilities, simulating AST filtering annotation
    public fun check_abilities(set: &AbilitySet) {
        // Intentionally empty, used for AST filtering check
        // pragma verify_terms = "AbilitySet abilities contain copy, drop, store"
        let _ = *set;
    }
}



//# run 0xCAFE::AbilityTest::create_ability_set --signers 0xBEEF


//# run 0xCAFE::AbilityTest::check_abilities --signers 0xBEEF

// Features:
// 54aec8a306571d53a83df563ed7c4f5c: Annotate Move spec blocks with 'pragma' clauses specifying comma-separated properties
// 1831330fadc45f430f99ce2e8c9b6445: List each ability in the provided AbilitySet separated by spaces.
// 94c414d896fd044e3e113f97fb8b963e: Apply AST filtering for verification purposes.