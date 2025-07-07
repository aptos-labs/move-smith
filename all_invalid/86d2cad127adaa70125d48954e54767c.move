//# publish
module 0xCAFE::AbilityConstraintsTest {
    use std::debug;
    use std::ability_constraints;

    // A struct that requires key ability
    struct KeyHolder has key {
        id: u64,
    }

    // A struct that requires store ability
    struct StoreHolder has store {
        data: u64,
    }

    // A struct with multiple abilities: key + store + drop
    struct MultiAbility has key, store, drop {
        value: u64,
    }

    // Generic struct with ability constraint requiring key ability
    struct GenericKeyHolder<T: key> has key {
        inner: T,
    }

    // Generic struct with multiple ability constraints (key + drop)
    struct GenericKeyDropHolder<T: key + drop> has key, drop {
        inner: T,
    }

    // Function returning ability constraints debug string
    public fun get_abilities<T>(): vector<u8> {
        ability_constraints_ast_debug<T>()
    }

    // Runner function exercising ability_constraints_ast_debug for various abilities
    public fun runner() {
        let _ = ability_constraints_ast_debug<KeyHolder>();
        debug::print(&ability_constraints_ast_debug<KeyHolder>());

        let _ = ability_constraints_ast_debug<StoreHolder>();
        debug::print(&ability_constraints_ast_debug<StoreHolder>());

        let _ = ability_constraints_ast_debug<MultiAbility>();
        debug::print(&ability_constraints_ast_debug<MultiAbility>());

        let _ = ability_constraints_ast_debug<GenericKeyHolder<KeyHolder>>();
        debug::print(&ability_constraints_ast_debug<GenericKeyHolder<KeyHolder>>());

        let _ = ability_constraints_ast_debug<GenericKeyDropHolder<MultiAbility>>();
        debug::print(&ability_constraints_ast_debug<GenericKeyDropHolder<MultiAbility>>());
    }

    // Spec with an invariant and a function with specification
    spec module {
        invariant true;

        spec fun spec_function(x: u64) {
            assert!(x > 0, 1);
        }
    }
}

//# run 0xCAFE::AbilityConstraintsTest::runner --signers 0xCAFE


//# run
script {
    use std::debug;
    use 0xCAFE::AbilityConstraintsTest;

    fun main() {
        // Call the runner function to exercise ability_constraints_ast_debug printing
        AbilityConstraintsTest::runner();

        // Spec functions cannot be called in scripts: but let's do some dummy usage of structs to test type constraints

        // Create instances with the expected abilities

        let _key_holder = AbilityConstraintsTest::KeyHolder { id: 1 };
        let _store_holder = AbilityConstraintsTest::StoreHolder { data: 42 };
        let _multi_ability = AbilityConstraintsTest::MultiAbility { value: 99 };

        let _generic_key_holder = AbilityConstraintsTest::GenericKeyHolder<KeyHolder> { inner: _key_holder };

        let _generic_key_drop_holder = AbilityConstraintsTest::GenericKeyDropHolder<AbilityConstraintsTest::MultiAbility> { inner: _multi_ability };

        debug::print(b"Script execution done");
    };
}

// Featurres:
// 1f1e15d73a91ef2d9e16f4165568f8a3: Include ability constraints in type parameter declarations to enforce capabilities.
// c7a8830f100bf1dde9ec0b76a6f1d34d: Use the `ability_constraints_ast_debug` function to display the abilities as a debug string with a colon and space prefix when abilities are present.
// befbd44b25f972db977a1c9b71c39e28: Declare specifications (specs) within modules.
