
//# publish
module 0xCAFE::AbilityInference {
    use std::signer;
    use std::vector;

    // Define structs with different ability sets
    struct CopyStruct has copy, drop, store {
        val: u8
    }

    struct DropStruct has drop, store {
        val: u64
    }

    struct StoreStruct has store {
        val: u128
    }

    // Function that takes generic types with ability constraints,
    // it defines multiple functions with unique names,
    // relying on compiler to infer acquires automatically.
    //
    // Note: We do not provide acquires annotation explicitly here.

    public fun handle_copy<T: copy>(value: T): T {
        // Just return the value
        value
    }

    public fun handle_drop<T: drop>(value: T): T {
        // Just return the value
        value
    }

    public fun handle_store<T: store>(value: T): T {
        // Just return the value
        value
    }

    // Function to convert list of ability constraints (represented as vector<u8>)
    // into a set-based representation (vector<bool> with specific indexes).
    //
    // The mapping is as follows:
    // 0 = copy
    // 1 = drop
    // 2 = store
    // We store presence of ability in positions.
    //
    // For testing purpose, input vector<u8> may contain duplicates or out-of-order entries.

    public fun abilities_to_set(abilities: vector<u8>): vector<bool> {
        let set = vector::empty<bool>();
        // Initialize set with false, size = 3
        vector::push_back(&mut set, false);
        vector::push_back(&mut set, false);
        vector::push_back(&mut set, false);

        let len = vector::length(&abilities);
        let i = 0;
        while (i < len) {
            let a = *vector::borrow(&abilities, i);
            if (a < 3) {
                // set[a] = true
                *vector::borrow_mut(&mut set, a) = true;
            };
            i = i + 1;
        };
        set
    }

    // Runner function to test abilities_to_set with various inputs
    public fun runner_abilities_to_set() {
        let vals_0 = vector[0u8, 1u8, 2u8];
        let _set_0 = abilities_to_set(vals_0);

        let vals_1 = vector[2u8, 2u8, 0u8];
        let _set_1 = abilities_to_set(vals_1);

        let vals_2 = vector[1u8, 1u8, 1u8];
        let _set_2 = abilities_to_set(vals_2);

        let vals_3 = vector[3u8, 4u8];
        let _set_3 = abilities_to_set(vals_3);
    }
}


//# run 0xCAFE::AbilityInference::handle_copy --args 42u8


//# run 0xCAFE::AbilityInference::handle_drop --args 123456789u64


//# run 0xCAFE::AbilityInference::handle_store --args 987654321u128


//# run 0xCAFE::AbilityInference::runner_abilities_to_set


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
