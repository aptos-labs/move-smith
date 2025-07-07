
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
        let _r = match();
    }

    public fun get_types_vector(): vector<type_info::TypeInfo> {
        // Convert a vector of types into expanded types via types()
        let types_vec = vector[
            type_info::type_of<u8>(),
            type_info::type_of<u16>(),
            type_info::type_of<bool>()
        ];
        types(types_vec)
    }
}


//# run 0xCAFE::FriendMatchTypes::call_match_no_args


//# run 0xCAFE::FriendMatchTypes::get_types_vector


// Featurres:
// fe6a973bbced6f5a4f50cbd27a92afd4: Terminate friend declarations with a semicolon.
// 213ad7ba72eaba483422d1a562f9c7db: Use 'match' as a function call 'match()' with no arguments.
// f1f19f8e66b166f16363b1c73b005181: Use the 'types' function to convert a vector of Move types into a vector of expanded Move types.
