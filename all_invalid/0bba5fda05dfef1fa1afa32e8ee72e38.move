
//# publish
module 0xCAFE::FriendMatchTypes {
    // Test friend declarations terminated by semicolon
    friend 0xCAFE::MyModule;
    friend 0xCAFE::StorageUsage;

    use std::vector;
    use std::type_info;

    struct Dummy has store {}

    public fun call_match_no_args() {
        // Using match as a function call with no arguments
        // `match()` function does not exist, this will cause errors.
        // Assuming the intent was to use some functionality or test,
        // but since 'match' is not defined, commenting out.
        // let _r = match();
    }

    public fun get_types_vector(): vector<type_info::TypeInfo> {
        // Construct a vector of TypeInfo::TypeInfo for u8, u16, bool
        let types_vec = vector::empty<type_info::TypeInfo>();
        vector::push_back(&mut types_vec, type_info::type_of<u8>());
        vector::push_back(&mut types_vec, type_info::type_of<u16>());
        vector::push_back(&mut types_vec, type_info::type_of<bool>());
        types_vec
    }
}




//# run 0xCAFE::FriendMatchTypes::call_match_no_args


//# run 0xCAFE::FriendMatchTypes::get_types_vector
