
//# publish
module 0xCAFE::SpecExampleModule {
    use std::signer;

    struct Token<phantom T: copy + drop + store> has store, drop {
        value: u64,
    }

    public fun create_token<T: copy + drop + store>(initial_value: u64): Token<T> {
        Token<T> { value: initial_value }
    }

    public fun get_value<T: copy + drop + store>(token: &Token<T>): u64 {
        token.value
    }

    spec module {
        use 0xCAFE::SpecExampleModule;
        use std::vector;

        invariant forall<TokenType> {
            // Example invariant: token value is always less than a large number
            // Just a dummy invariant for stress test of spec blocks
            exists[token: Token<TokenType>] (token.value < 1000000)
        }
    }

    spec Token<T> {
        // Spec that field value never exceeds 1_000_000
        invariant self.value <= 1_000_000;
    }
}


//# run 0xCAFE::SpecExampleModule::create_token --args 42u64


//# run 0xCAFE::SpecExampleModule::get_value --args 0x0 /* fake address, dummy ref */


//# publish
module 0xCAFE::NestedSpecBlockModule {
    struct Wrapper has store, copy, drop {
        data: u8,
    }

    public fun make_wrapper(val: u8): Wrapper {
        Wrapper { data: val }
    }

    spec module {
        use 0xCAFE::NestedSpecBlockModule;
        use std::option;

        // Spec block with multiple use declarations and members inside braces
        spec {
            const MAX_VAL: u8 = 255;

            spec fun valid_wrapper(w: Wrapper): bool {
                w.data <= MAX_VAL
            }

            invariant forall(w: Wrapper) valid_wrapper(w)
        }
    }
}


//# run 0xCAFE::NestedSpecBlockModule::make_wrapper --args 123u8



//# publish
module 0xCAFE::AbilityConstraints {
    struct AbilitiedStruct<T: copy + drop + store + key, U: store + key> has store, key {
        a: T,
        b: U,
    }

    public fun mk_abilitied<T: copy + drop + store + key, U: store + key>(a: T, b: U): AbilitiedStruct<T, U> {
        AbilitiedStruct<T, U> { a, b }
    }

    spec module {
        use 0xCAFE::AbilityConstraints;

        // Spec block testing complex ability constraints on type parameters
        spec fun type_param_constraints<T: copy + drop + store + key, U: store + key>(): bool {
            true
        }
    }
}


//# run 0xCAFE::AbilityConstraints::mk_abilitied --args 0u8 0u8


// Featurres:
// 89f8f5a5053fd2c4219f777ba327bfd5: Define specification-only modules within normal Move modules or address blocks and have them handled distinctly by the compiler.
// c27bfd0ddff886e382b79619db313d1a: Organize spec block contents using a syntax that allows multiple 'use' declarations and members inside braces.
// 184619619054074649b3e2fb51304916: Define type parameters with specific abilities and constraints in Move code.
