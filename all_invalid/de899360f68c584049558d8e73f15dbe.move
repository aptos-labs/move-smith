//# publish
module 0xCAFE::AbilityUtils {
    use std::string;

    /// Converts an AbilitySet to a string representation.
    /// Format: if empty, return "", else ": ability1+ ability2+ ...+ abilityN"
    public fun abilities_to_string<phantom T>(): string::String {
        let abilities = ability_of<T>();
        ability_set_to_str(abilities)
    }

    native fun ability_of<phantom T>(): u8;

    fun ability_set_to_str(abilities: u8): string::String {
        // Constants matching abiility bits in Aptos:
        // copy = 1, drop = 2, store = 4, key = 8, all together sum to 15 (0xF)
        // We'll just map them in order:
        let copy = 1;
        let drop = 2;
        let store = 4;
        let key = 8;

        if (abilities == 0) {
            string::utf8("") // empty string
        } else {
            // Build list of ability names that exist, separated by "+ "
            // We accumulate in a vector and join at the end
            let mut parts = vector::empty<string::String>();

            if ((abilities & copy) == copy) {
                vector::push_back(&mut parts, string::utf8("copy"));
            }
            if ((abilities & drop) == drop) {
                vector::push_back(&mut parts, string::utf8("drop"));
            }
            if ((abilities & store) == store) {
                vector::push_back(&mut parts, string::utf8("store"));
            }
            if ((abilities & key) == key) {
                vector::push_back(&mut parts, string::utf8("key"));
            }

            // Join parts with '+ '
            let mut result = string::utf8(": ");
            let len = vector::length(&parts);
            let mut i = 0;
            while (i < len) {
                result = string::append(&result, &vector::borrow(&parts, i));
                if (i < len - 1) {
                    result = string::append(&result, &string::utf8("+ "));
                }
                i = i + 1;
            }
            result
        }
    }
}

//# run 0xCAFE::AbilityUtils::abilities_to_string

//# publish
module 0xCAFE::ResourceModule {
    use std::signer;
    use std::string;

    /// Declare a resource struct using 'resource struct'
    resource struct R1 has key, store {}

    /// Another resource with fewer abilities
    resource struct R2 has key {}

    /// Runner function to test AbilityUtils on R1 and R2
    public fun run() {
        let s1 = 0xCAFE::AbilityUtils::abilities_to_string<R1>();
        let s2 = 0xCAFE::AbilityUtils::abilities_to_string<R2>();
        // We ignore output since no assertions needed
        let _ = s1;
        let _ = s2;
    }
}
//# run 0xCAFE::ResourceModule::run

//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::string;

    /// Just a simple resource struct for further test
    resource struct R3 has key, copy {}

    /// Store a value for demonstration
    resource struct DataHolder has key, store {
        value: u64,
    }

    /// Store data at account
    public fun store_value(account: &signer, val: u64) {
        move_to(account, DataHolder { value: val });
    }

    /// Get abilities string of R3 type
    public fun get_r3_abilities_str(): string::String {
        0xCAFE::AbilityUtils::abilities_to_string<R3>()
    }

    /// Runner function with no args that calls store_value (with signer) and abilities_to_string
    public fun run(account: &signer) {
        store_value(account, 42);
        let ab_str = get_r3_abilities_str();
        let _ = ab_str;
    }

}
//# run 0xCAFE::TestModule::run --signers 0xCAFE

//# run 0xCAFE::TestModule::store_value --signers 0xCAFE --args 123u64

//# run 0xCAFE::TestModule::get_r3_abilities_str

// Featurres:
// 0081d31df4108b9705ff56d6cf74e407: Arrange modules and scripts in dependency order for compilation.
// 6ab8797b66a06348f368b697382c1c80: Declare resources as 'resource struct StructName' instead of 'resource StructName'.
// 96be6c377d8274e3193f9ddf4bc955c1: Convert an AbilitySet to a string that lists its abilities separated by '+ ' and prefixed with ': ' when it is not empty.
