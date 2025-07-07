
//# publish
module 0xCAFE::ComplexAccessSpecifiers {
    use std::signer;

    // Fix: remove trailing comma after abilities; no comma allowed after last ability
    struct User has copy, drop, store, key {
        id: u64,
        name: vector<u8>,
        active: bool,
    }

    struct Wrapper has store {
        user: 0xCAFE::ComplexAccessSpecifiers::User,
        created: u64,
    }

    // Fix: access specifiers list must not have commas in functions (only spaces)
    public entry fun create_user(s: signer, id: u64, name: vector<u8>) {
        let user = User {
            id,
            name,
            active: true,
        };
        move_to<User>(&s, user);
    }

    public fun read_user(s: signer): (u64, vector<u8>, bool) {
        let user_ref = borrow_global<User>(signer::address_of(&s));
        (user_ref.id, copy user_ref.name, user_ref.active)
    }

    // Fix: friend and public are space-separated without comma for access specifiers on functions
    friend public fun deactivate_user(s: signer) {
        let user_ref_mut = borrow_global_mut<User>(signer::address_of(&s));
        user_ref_mut.active = false;
    }

    public fun create_wrapper(s: signer, id: u64, name: vector<u8>, created: u64) {
        let user = User {
            id,
            name,
            active: true,
        };
        let wrapper = Wrapper {
            user,
            created,
        };
        move_to<Wrapper>(&s, wrapper);
    }
}



//# run 0xCAFE::ComplexAccessSpecifiers::create_user --signers 0xBEEF --args 42u64 b"TestUser"


//# run 0xCAFE::ComplexAccessSpecifiers::read_user --signers 0xBEEF


//# run 0xCAFE::ComplexAccessSpecifiers::deactivate_user --signers 0xBEEF


//# run 0xCAFE::ComplexAccessSpecifiers::read_user --signers 0xBEEF


//# run 0xCAFE::ComplexAccessSpecifiers::create_wrapper --signers 0xBEEF --args 100u64 b"WrappedUser" 365u64
