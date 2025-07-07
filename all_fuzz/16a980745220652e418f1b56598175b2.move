
//# publish
module 0xCAFE::AbilityConstraints {
    use std::vector;

    // Define an enum to represent abilities
    // We must add abilities on Ability so it can be stored in vector
    // Require copy, drop, store for vector<Ability>
    enum Ability has copy, drop, store {
        COPY,
        DROP,
        STORE,
        KEY,
    }

    // A struct representing a single type parameter's constraints as a vector/set of abilities
    // Must have the abilities required by the vector field
    struct AbilitySet has copy, drop, store {
        abilities: vector<Ability>
    }

    // Converts a list of abilities into a set-like AbilitySet (no duplicates)
    public fun abilities_to_set(abilities: vector<Ability>): AbilitySet {
        let set = vector::empty<Ability>();
        let len = vector::length(&abilities);
        let i = 0;
        while (i < len) {
            let ability = *vector::borrow(&abilities, i);
            if (!ability_in_vector(ability, &set)) {
                vector::push_back(&mut set, ability);
            };
            i = i + 1;
        };
        AbilitySet { abilities: set }
    }

    // Helper function to check if ability is in vector
    fun ability_in_vector(ability: Ability, abilities: &vector<Ability>): bool {
        let len = vector::length(abilities);
        let i = 0;
        while (i < len) {
            if (*vector::borrow(abilities, i) == ability) {
                return true;
            };
            i = i + 1;
        };
        false
    }

    // Function taking type parameters with ability constraints; relies on compiler to infer acquires
    public fun constrained_identity<T: copy + drop>(val: T): T {
        val
    }

    // Another function with unique name taking different constrained type param
    public fun constrained_key<T: key>(addr: &T) {
        // dummy no-op function to test type parameter constraint
    }

    // A runner function to test abilities conversion
    public fun test_abilities_set_conversion() {
        let abilities = vector[
            Ability::COPY,
            Ability::DROP,
            Ability::COPY,
            Ability::STORE,
            Ability::KEY,
            Ability::STORE
        ];
        let _set = abilities_to_set(abilities);
        // just ignoring result; no assertion needed
    }
}



//# run 0xCAFE::AbilityConstraints::test_abilities_set_conversion



//# run 0xCAFE::AbilityConstraints::constrained_identity --args 42u8



//# run 0xCAFE::AbilityConstraints::constrained_key --args @0xCAFE
