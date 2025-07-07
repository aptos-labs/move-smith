
//# publish
module 0xCAFE::TypeParamAbilities {

    /// A struct to represent an Ability set as a vector of string identifiers
    struct AbilitySet has store {
        abilities: vector<vector<u8>>,
    }

    /// Private helper: create an AbilitySet from a vector of ability strings
    fun create_ability_set(abilities: vector<vector<u8>>): AbilitySet {
        AbilitySet { abilities }
    }

    /// Public function to convert a list of type parameters with ability constraints
    /// into a set-based representation (vector of ability sets)
    /// Each type parameter is associated with a set of abilities represented as strings,
    /// e.g., "copy", "drop", "store", "key"
    public fun convert_abilities_list_to_set() {
        let abilities_1 = vector[b"copy", b"drop"];
        let abilities_2 = vector[b"store"];
        let abilities_3 = vector[b"key", b"store"];
        let sets = vector[
            create_ability_set(abilities_1),
            create_ability_set(abilities_2),
            create_ability_set(abilities_3),
        ];
        // No return value needed; just tests compiler type inference and usage
    }

    /// Another version of conversion function with different data to test uniqueness
    public fun convert_abilities_list_to_set_unique() {
        let abilities_1 = vector[b"store", b"copy"];
        let abilities_2 = vector[b"key"];
        let abilities_3 = vector[b"drop", b"store"];
        let sets = vector[
            create_ability_set(abilities_1),
            create_ability_set(abilities_2),
            create_ability_set(abilities_3),
        ];
    }

    /// A simple function that takes a type parameter T that has copy+drop abilities
    public fun generic_function_copy_drop<T: copy + drop>(val: T): T {
        val
    }

    /// Another generic function with a different name and a type parameter that has store ability
    public fun generic_function_store<T: store>(val: T) {
        // no op
    }
}


//# run 0xCAFE::TypeParamAbilities::convert_abilities_list_to_set


//# run 0xCAFE::TypeParamAbilities::convert_abilities_list_to_set_unique


//# run 0xCAFE::TypeParamAbilities::generic_function_copy_drop --args 42u8


//# run 0xCAFE::TypeParamAbilities::generic_function_store --args 100u64


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
