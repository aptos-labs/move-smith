
//# publish
module 0xCAFE::AbilityConstraints {
    use std::vector;
    use std::option;

    // Define an enum to represent abilities
    enum Ability {
        COPY,
        DROP,
        STORE,
        KEY,
    }

    // A struct representing a single type parameter's constraints as a vector/set of abilities
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


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
