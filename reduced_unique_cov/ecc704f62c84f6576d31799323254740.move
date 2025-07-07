
//# publish
module 0xCAFE::TestAcquireInferenceAndTypeParams {
    use std::signer;
    use std::vector;

    /// Struct with Store ability to test global storage and acquire inference
    struct Data<T> has store, key {
        value: T
    }

    /// A simple struct with copy, drop, store for testing
    struct Simple has copy, drop, store {
        a: u8,
        b: u8
    }

    /// Function to create and move to global storage Data<u8>
    public fun store_u8(s: signer, val: u8) {
        let d = Data<u8> { value: val };
        move_to<Data<u8>>(&s, d);
    }

    /// Function to create and move to global storage Data<Simple>
    public fun store_simple(s: signer, a: u8, b: u8) {
        let simple = Simple { a, b };
        let d = Data<Simple> { value: simple };
        move_to<Data<Simple>>(&s, d);
    }

    /// Returns the sum of a and b fields in stored Simple struct at signer address
    public fun sum_simple_fields(s: signer): u8 {
        let d_ref = borrow_global<Data<Simple>>(signer::address_of(&s));
        d_ref.value.a + d_ref.value.b
    }

    /// Converts a list of abilities from a vector<bool> to a set of ability names in vector<u8> 
    /// Dummy conversion representing abilities as numbers: Store=1, Copy=2, Drop=3, Key=4
    /// Input vector<bool> length 4, each index represent ability presence
    public fun ability_list_to_set(abilities: vector<bool>): vector<u8> {
        let set = vector::empty<u8>();
        if (*vector::borrow(&abilities, 0)) {
            vector::push_back(&mut set, 1); // Store
        };
        if (*vector::borrow(&abilities, 1)) {
            vector::push_back(&mut set, 2); // Copy
        };
        if (*vector::borrow(&abilities, 2)) {
            vector::push_back(&mut set, 3); // Drop
        };
        if (*vector::borrow(&abilities, 3)) {
            vector::push_back(&mut set, 4); // Key
        };
        set
    }

    /// A simple function with no parameters that returns a u8 value to test uniqueness of function names
    public fun unique_fn1(): u8 {
        42u8
    }

    /// Another unique-named function also returning u8 value
    public fun unique_fn2(): u8 {
        24u8
    }
}



//# run 0xCAFE::TestAcquireInferenceAndTypeParams::store_u8 --signers 0xBEEF --args 100u8



//# run 0xCAFE::TestAcquireInferenceAndTypeParams::store_simple --signers 0xBEEF --args 12u8 30u8



//# run 0xCAFE::TestAcquireInferenceAndTypeParams::sum_simple_fields --signers 0xBEEF



//# run 0xCAFE::TestAcquireInferenceAndTypeParams::ability_list_to_set --args true false true true



//# run 0xCAFE::TestAcquireInferenceAndTypeParams::unique_fn1



//# run 0xCAFE::TestAcquireInferenceAndTypeParams::unique_fn2
