//# publish
module 0xCAFE::AddressAbilityConst {
    use std::string;
    use std::ability;

    // AbilitySet constant with abilities copy and drop
    const CopyDropAbilities: ability::AbilitySet = ability::copy() | ability::drop();

    // Struct with uppercase name and abilities specified explicitly
    struct AStruct has key, copy, drop {
        value: u8,
    }

    // Schema with uppercase name (in Move schemas are not explicit, we simulate with struct and constants)
    struct BSchema has copy, drop {
        flag: bool,
    }

    // Parses an address from a string using std::string and std::address
    public fun parse_address(): address {
        // The string literal of the address (hex string)
        let addr_str = b"CAFE0000000000000000000000000000";

        let addr = std::address::from_hex_string(addr_str);
        addr
    }

    // Function to get the ability set constant, returns it as u8 bitmask for illustration
    public fun get_copy_drop_abilities(): u8 {
        ability::abilities_to_u8(CopyDropAbilities)
    }

    // Create and return an instance of AStruct
    public fun create_astruct(): AStruct {
        AStruct { value: 42 }
    }

    // Create and return an instance of BSchema
    public fun create_bschema(): BSchema {
        BSchema { flag: true }
    }

    // Runner function to demonstrate usage without args
    public fun runner() {
        let _addr = parse_address();
        let _abilities = get_copy_drop_abilities();
        let a = create_astruct();
        let b = create_bschema();
        let _ = a.value;
        let _ = b.flag;
    }
}

//# run 0xCAFE::AddressAbilityConst::runner

// Featurres:
// 05775f887f44514bef70890eb76294b1: Parse address bytes from a string representation in Move code.
// 97c7fa2bfc8addd72bdb2c35fc6eba63: Use AbilitySet to specify a set of abilities for a Move type.
// e0625019b1a4d12e7166f2a441c05c98: Define constant, struct, and schema names that start with an uppercase letter ('A'..'Z').
