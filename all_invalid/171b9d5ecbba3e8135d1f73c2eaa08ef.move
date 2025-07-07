script {
    use std::signer;
}

module 0x1::TestAttributesAndAbilities {
    // Define some abilities for testing
    struct HasKeyAbility has key {}
    struct HasStoreAbility has store {}
    struct HasCopyAbility has copy {}
    struct HasDropAbility has drop {}

    // 1. Annotate your Move code with attributes that have either constant values
    // or module-qualified identifiers as their values.

    const CONST_VALUE: u64 = 42;

    #[const_attr = CONST_VALUE]
    #[module_attr = 0x1::TestAttributesAndAbilities::HasKeyAbility]
    struct AnnotatedStruct has key, store {
        // 3. Write comma-separated lists of elements in Move code, struct fields
        field1: u64,
        field2: address,
        field3: bool,
    }

    // To test module-qualified identifiers as attribute values on function
    #[function_attr = 0x1::TestAttributesAndAbilities::HasStoreAbility]
    public fun annotated_function(s: &signer, x: u64, y: address) acquires AnnotatedStruct {
        let a = AnnotatedStruct {
            field1: x,
            field2: y,
            field3: true,
        };
        // Do something with a to avoid unused warnings
        let _ = a;
    }

    // 2. List each ability in the provided AbilitySet separated by spaces.
    // Define a struct specifying abilities in a comment and implementation
    //
    // Abilities: key store copy drop
    struct MultipleAbilitiesStruct has key store copy drop {
        val: u8,
    }

    // Use comma-separated parameter list in a function
    public fun create_struct(
        addr: address,
        num: u64,
        flag: bool
    ): AnnotatedStruct {
        AnnotatedStruct {
            field1: num,
            field2: addr,
            field3: flag,
        }
    }
}

script {
    use std::signer;

    fun main(account: signer) {
        // Call the annotated function with comma-separated arguments
        0x1::TestAttributesAndAbilities::annotated_function(&account, 7, signer::address_of(&account));

        // Create an instance of AnnotatedStruct using create_struct
        let _ = 0x1::TestAttributesAndAbilities::create_struct(signer::address_of(&account), 123, true);
    }
}

// Featurres:
// acf0a8237c18af53c3ab3a951204da8b: Annotate your Move code with attributes that have either constant values or module-qualified identifiers as their values.
// 1831330fadc45f430f99ce2e8c9b6445: List each ability in the provided AbilitySet separated by spaces.
// 2db8483833080785fd845c41e4ac7367: Write comma-separated lists of elements in Move code, such as parameter lists, struct fields, or similar constructs
