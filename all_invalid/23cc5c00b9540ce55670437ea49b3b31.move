
//# publish
    module CastingModule {
        public fun cast_examples(): (u64, u128) {
            let a: u8 = 5u8;
            let b: u64 = a as u64;
            let c: u128 = b as u128;
            (b, c)
        }
    }

    // invariant [true] + self > 10u64]
//# publish
    module SpecInvariantModule {
        use std::string;

        struct InvariantStruct has store {
            val: u64,
        }

        // invariant [val > 0u64] + val < 100u64] // condition property in invariant
        public fun create(val: u64): InvariantStruct {
            InvariantStruct { val }
        }
    }
}


//# publish
    module AddrBlockModule {
        use std::vector;

        struct Data has copy, drop, store {
            nums: vector<u8>
        }

        public fun new_data(): Data {
            let v = vector[1u8, 2u8, 3u8];
            Data { nums: v }
        }
    }
}


//# run 0xCAFE::CastingModule::cast_examples


//# run 0xCAFE::SpecInvariantModule::create --args 25u64


//# run 0xBEEF::AddrBlockModule::new_data


// Featurres:
// f0e457d86e032295768c1cb5820f1784: Cast expressions or annotate expressions with a specified type.
// a871749d39b7d0f3b41f2eb092d92571: Add additional properties to invariants using condition properties syntax in spec blocks.
// ada67865bddc808bf8b520da8bb122bb: Define named Move address blocks that contain modules and attributes.
