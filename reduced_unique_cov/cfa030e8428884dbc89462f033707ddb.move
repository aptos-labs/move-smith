
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::vector;
    use std::signer;

    // Feature 1: Omit the acquires annotation, rely on compiler to infer.
    struct Data has store, key {
        id: u64,
        value: u8,
    }

    public fun publish_data(s: signer, id: u64, value: u8) {
        let data = Data { id, value };
        move_to<Data>(&s, data);
    }

    public fun update_data(s: signer, new_value: u8) {
        let data_ref = borrow_global_mut<Data>(signer::address_of(&s));
        data_ref.value = new_value;
    }

    // Feature 2: Convert a list of type parameters with ability constraints into a set-based representation.

    // Represents ability as bit flags for demonstration
    const ABILITY_COPY: u8 = 0x01;
    const ABILITY_DROP: u8 = 0x02;
    const ABILITY_STORE: u8 = 0x04;
    const ABILITY_KEY: u8 = 0x08;

    // Helper function to represent a set of abilities as a byte set
    fun abilities_to_set(copy: bool, drop: bool, store: bool, key: bool): u8 {
        let set = 0u8;
        if (copy) {
            set = set | ABILITY_COPY;
        };
        if (drop) {
            set = set | ABILITY_DROP;
        };
        if (store) {
            set = set | ABILITY_STORE;
        };
        if (key) {
            set = set | ABILITY_KEY;
        };
        set
    }

    // Public function converting type parameter abilities to set
    public fun type_param_abilities_to_set<T>() : u8 {
        let copy = has_copy<T>();
        let drop = has_drop<T>();
        let store = has_store<T>();
        let key = has_key<T>();
        abilities_to_set(copy, drop, store, key)
    }

    // Feature 3: Define several functions with unique names inside same module.

    public fun unique_f0(): u8 {
        0
    }

    public fun unique_f1(): u8 {
        1
    }

    public fun unique_f2(): u8 {
        2
    }

    public fun unique_runner() {
        let _ = unique_f0();
        let _ = unique_f1();
        let _ = unique_f2();
    }
}



//# run 0xCAFE::AdvancedFeatures::publish_data --signers 0xDEAD --args 42u64 7u8



//# run 0xCAFE::AdvancedFeatures::update_data --signers 0xDEAD --args 9u8



//# run 0xCAFE::AdvancedFeatures::type_param_abilities_to_set --type-args u8



//# run 0xCAFE::AdvancedFeatures::type_param_abilities_to_set --type-args vector<u8>



//# run 0xCAFE::AdvancedFeatures::unique_runner


// Features:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
