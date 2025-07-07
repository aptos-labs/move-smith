
//# publish
module 0xCAFE::TestUnusedStructParam {
    use std::vector;

    // Test for unused struct parameters
    struct Person has copy, drop, store {
        unused_field: u8,
        used_field: u16,
    }

    public fun create_person() {
        let _p = Person {unused_field: 0, used_field: 42};
        // used_field is used below
        let _value = get_used_field(&Person {unused_field: 0, used_field: 42});
    }

    public fun get_used_field(p: &Person): u16 {
        p.used_field
    }
}

module 0xCAFE::FriendModule {
    // Declare friend modules to allow access to certain functions
    friend 0xCAFE::TestUnusedStructParam;

    use std::signer;

    public fun access_private_data(s: signer) {
        // Call function in friend module that accesses private data
        0xCAFE::TestUnusedStructParam::create_person();
    }
}


//# run 0xCAFE::TestUnusedStructParam::create_person

//# run 0xCAFE::FriendModule::access_private_data --signers 0xBEEF

// Featurres:
// 9ec8e91bb42b5c81ffbf1c002cdcc6f5: Check for unused struct parameters.
// fe6a973bbced6f5a4f50cbd27a92afd4: Terminate friend declarations with a semicolon.
// b692c45d043300d3535702c47bf641f3: Declare friend modules to grant access privileges from other modules.
