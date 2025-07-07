
//# publish
module 0xCAFE::GenericFunctions {
    use std::signer;

    // Define a struct with key ability
    struct Container<T> has store {
        value: T
    }

    // Generic function with ability constraints: T has copy + store
    public fun store_generic<T: copy + store>(acct: &signer, v: T) {
        let c = Container<T> { value: v };
        move_to<Container<T>>(acct, c);
    }

    // Generic function reading from Container<T>, T has copy + store
    public fun read_generic<T: copy + store>(addr: address): T acquires Container {
        let c_ref = borrow_global<Container<T>>(addr);
        c_ref.value
    }

    // Function using numeric token to identify positional fields in structs
    // (simulate with multiple fields and use numeric suffix)
    struct PositionalFields has copy, drop, store {
        _0: u8,
        _1: u16,
        _2: bool,
    }

    // Create a PositionalFields struct with numeric field names
    public fun create_positional(): PositionalFields {
        PositionalFields { _0: 42u8, _1: 65535u16, _2: true }
    }
}


//# run 0xCAFE::GenericFunctions::store_generic --signers 0xBEEF --args 123u8


//# run 0xCAFE::GenericFunctions::read_generic<u8> --args 0xBEEF


//# run 0xCAFE::GenericFunctions::create_positional


// Featurres:
// e5d5a8872369648d737b218c87dbd0f6: Define generic functions with type parameters that have specific ability constraints.
// 1ec968b9866c644bfe28fd6c982f270e: Use numeric tokens to identify positional fields in Move code.
// 3de85dae439018dd0f5193f82ca4cadc: Specify 'public' visibility for functions or modules.
