//# publish
address 0xCAFE {
    pragma allow_republishing;
    pragma some_property = true;

    module AccessControlDemo {
        // A public function that anyone can call
        public fun public_function() {
        }

        // An internal function (only callable within this module)
        fun internal_function() {
        }

        // A friend function (callable only by 0xCAFE::FriendModule)
        friend fun friend_function() {
        }

        // A function callable only by 0xCAFE address (i.e. signer must be 0xCAFE)
        public(script) fun only_cafe_signer(_signer: &signer) {
        }

        // Runner function to call internal and friend functions (to cover compilation)
        public fun runner() {
            internal_function();
            friend_function();
        }
    }
}

//# run 0xCAFE::AccessControlDemo::runner

//# run 0xCAFE::AccessControlDemo::only_cafe_signer --signers 0xCAFE

//# publish
address 0xCAFE {
    module IntegerLiterals {
        // Using inferred-width integer literals (no suffix) in various constants and functions

        const CONST_INF_INT: u128 = 1000000000000000000000000000000;

        // Function using inferred-width integer literal, takes no argument and returns u128
        public fun use_inferred_literal(): u128 {
            let x = 5000000000000000000; // inferred to u128
            let y = 123456789012345678901234567890; // inferred to u128
            x + y
        }

        // Runner function to just invoke use_inferred_literal
        public fun runner(): u128 {
            use_inferred_literal()
        }
    }
}

//# run 0xCAFE::IntegerLiterals::runner

//# publish
address 0xCAFE {
    pragma example_pragma; // pragma with no value
    pragma experimental_feature = "enabled";

    module PragmaProperties {
        // An empty module with pragmas to test pragma syntax with optional values
        public fun runner() {
        }
    }
}

//# run 0xCAFE::PragmaProperties::runner

// Featurres:
// 894fc8f7804d6e73ab15b1e587abd535: Define function access specifiers to refine access control beyond basic visibility, such as restricting invocation to specific modules or addresses.
// c75d7359b63fbb705a37fec34c1e69b3: Use inferred-width integer literals in Move code (automatically using the largest integer type possible if no suffix is provided).
// a735c1d4c3d782d8f12465c8710f9f57: Specify pragma properties with optional values in Move code
