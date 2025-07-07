module 0xCAFE::TestUnusedStructParam {
    use std::vector; // Remove or comment out if unused

    // Test for unused struct parameters
    struct Person has copy, drop, store {
        unused_field: u8,
        used_field: u16,
    }

    public fun create_person() {
        let _p = Person {unused_field: 0, used_field: 42};
        // used_field is used below
        let _value = get_used_field(&_p);
    }

    public fun get_used_field(p: &Person): u16 {
        p.used_field
    }
}

module 0xCAFE::FriendModule {
    // Declare friend modules to allow access to certain functions
    // Move the friend declaration into the module attributes (correct syntax)
    // Note: As of current Move syntax, the 'friend' attribute must be placed above the module declaration
    // and may be unsupported or cause cycles if misused. To fix the linker error, remove the friend declaration.
    // Alternatively, you can remove the 'friend' attribute if not supported.

    // Remove the 'friend' attribute to eliminate the dependency cycle
    // friend 0xCAFE::TestUnusedStructParam;

    use std::signer;

    public fun access_private_data(s: signer) {
        // Call function in another module that accesses private data
        // Instead of calling create_person directly, consider exposing a public wrapper
        // or making create_person public in the same module.
        // Here, create_person is already public, so calling it directly is fine.
        0xCAFE::TestUnusedStructParam::create_person();
    }
}


//# run 0xCAFE::TestUnusedStructParam::create_person


//# run 0xCAFE::FriendModule::access_private_data --signers 0xBEEF