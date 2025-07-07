
//# publish
module 0xCAFE::FriendMatchTypes {
    // Test friend declarations terminated by semicolon
    friend 0xCAFE::MyModule;
    friend 0xCAFE::StorageUsage;

    use std::types;

    struct Dummy has store {}

    public fun call_match_no_args() {
        // Using match as a function call with no arguments
        let _r = match();
    }

    public fun get_types_vector(): vector<types::Type> {
        // Convert a vector of types into expanded types via types()
        let types_vec = vector[
            types::u8,
            types::u16,
            types::bool
        ];
        types(types_vec)
    }
}



//# run 0xCAFE::FriendMatchTypes::call_match_no_args



//# run 0xCAFE::FriendMatchTypes::get_types_vector
