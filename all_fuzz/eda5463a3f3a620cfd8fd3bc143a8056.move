
//# publish
module 0xCAFE::LintSuppress {
    // Demonstrate how to suppress specific lint checks with a skip list metadata attribute

    // skip_lint(expression_dead_code, expression_unused_variable)]
    public fun with_suppression(x: u8): u8 {
        let unused = 10u8;
        if (x > 5) {
            let _ = 1;
        } else {
            let _ = 2;
        };

        // This dead code will not trigger lint error due to suppression
        if (false) {
            let unused2 = 0u8;
        };

        x + 1
    }
}


//# run 0xCAFE::LintSuppress::with_suppression --args 3u8


address 0xCAFE {
    
//# publish
    module Constrain {
        use std::vector;

        struct TyParam has copy, drop {
            index: u8,
            abilities: u8, // bitmask representing abilities
        }

        // For demonstration, define abilities constants
        const ABILITY_COPY: u8 = 0x1;
        const ABILITY_DROP: u8 = 0x2;
        const ABILITY_STORE: u8 = 0x4;

        /// Converts a vector<TyParam> into a vector<u8> where each u8 encodes the abilities as bitmask
        public fun convert_to_ability_set(params: vector<TyParam>): vector<u8> {
            let result = vector::empty<u8>();
            let len = vector::length(&params);
            let i = 0;
            while (i < len) {
                let tp = *vector::borrow(&params, i);
                vector::push_back(&mut result, tp.abilities);
                i = i + 1;
            };
            result
        }

        public fun run_ability_conversion() {
            let params = vector::empty<TyParam>();
            vector::push_back(&mut params, TyParam {index: 0, abilities: ABILITY_COPY | ABILITY_DROP});
            vector::push_back(&mut params, TyParam {index: 1, abilities: ABILITY_STORE});
            let _sets = convert_to_ability_set(params);
        }
    }
}


//# run 0xCAFE::Constrain::run_ability_conversion


address 0xDEAD {
    
//# publish
    module AddressModule {
        public fun greet(): u8 {
            42u8
        }
    }
}


//# run 0xDEAD::AddressModule::greet


// Featurres:
// 9f1333973599009df8949420e15285ad: Suppress specific expression lint checks within a function by specifying them in the skip list.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
// ff0e1ae15b3f12bb2b442c47cdeae366: Declare a module inside an 'address <address> { ... }' block to assign the sender address.
