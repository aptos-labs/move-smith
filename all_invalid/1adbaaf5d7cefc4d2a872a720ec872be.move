
//# publish
module 0xCAFE::ComplexAccessSpecifiers {
    use std::signer;

    // Struct with multiple access specifiers including trailing comma
    struct User has copy, drop, store, key, {
        id: u64,
        name: vector<u8>,
        active: bool,
    }

    // Struct that references a struct from another module via chain of names
    struct Wrapper has store {
        user: 0xCAFE::ComplexAccessSpecifiers::User,
        created: u64,
    }

    // A public function using multiple access specifiers (public, entry) comma separated with trailing comma
    public, entry fun create_user(s: signer, id: u64, name: vector<u8>) {
        let user = User {
            id,
            name,
            active: true,
        };
        move_to<User>(&s, user);
    }

    // Public function to read user
    public fun read_user(s: signer): (u64, vector<u8>, bool) {
        let user_ref = borrow_global<User>(signer::address_of(&s));
        (user_ref.id, copy user_ref.name, user_ref.active)
    }

    // Internal function with multiple access specifiers (friend, public) testing comma separated list
    friend, public fun deactivate_user(s: signer) {
        let user_ref_mut = borrow_global_mut<User>(signer::address_of(&s));
        user_ref_mut.active = false;
    }

    // Function that uses struct wrapped from chained name
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


// Featurres:
// 242e7882aa1263866d1af91f1f1e6e5a: Specify struct fields with designated signatures and names.
// 9653b5b722d29da014d7a3da2f3ec2bb: Specify a comma-separated list of access specifiers in your Move code, allowing both trailing commas and multiple entries.
// 9a8847f893559f4ccdce63ae8c9c6dc0: Access modules and types through a chain of names using a specific syntax.
