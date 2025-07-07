
//# publish
module 0xCAFE::AccessControlTest {
    use std::signer;

    struct Resource has key, store {
        id: u64,
    }

    // Private function - accessible only inside this module
    fun private_create_resource(id: u64): Resource {
        Resource { id }
    }

    // Friend function - accessible only to friend modules (declared later)
    friend fun friend_modify_resource(res: &mut Resource, new_id: u64) {
        res.id = new_id;
    }

    // Public function to create a resource and move to account
    public fun create_and_store(s: signer, id: u64) acquires Resource {
        let res = private_create_resource(id);
        move_to<Resource>(&s, res);
    }

    // Public function to read resource id
    public fun get_resource_id(s: signer): u64 acquires Resource {
        let res_ref = borrow_global<Resource>(signer::address_of(&s));
        res_ref.id
    }

    // Private function to delete resource, only internal usage
    fun private_delete(s: signer) acquires Resource {
        let _res = move_from<Resource>(signer::address_of(&s));
    }

    // Public wrapper to delete resource
    public fun delete_resource(s: signer) acquires Resource {
        private_delete(s);
    }
}


//# publish
module 0xCAFE::FriendModule {
    use std::signer;
    use 0xCAFE::AccessControlTest;

    // Public function that modifies Resource using friend function
    public fun friend_modify(s: signer, new_id: u64) acquires AccessControlTest::Resource {
        let res_mut = borrow_global_mut<AccessControlTest::Resource>(signer::address_of(&s));
        AccessControlTest::friend_modify_resource(res_mut, new_id);
    }
}


//# run 0xCAFE::AccessControlTest::create_and_store --signers 0xBEEF --args 123u64


//# run 0xCAFE::AccessControlTest::get_resource_id --signers 0xBEEF


//# run 0xCAFE::FriendModule::friend_modify --signers 0xBEEF --args 456u64


//# run 0xCAFE::AccessControlTest::get_resource_id --signers 0xBEEF


//# run 0xCAFE::AccessControlTest::delete_resource --signers 0xBEEF


// Featurres:
// d9b03363776d57f6f09d4dd1d0f833cf: Annotate functions with acquire permissions to specify which resources are acquired during execution.
// 6671883b5bb4d8b099e86b2d8f615f3b: Enforce module-level privacy for functions within a module
// 61eb046aa92c303317f8da1054b49302: Use public, friend, and private visibility for functions to control their accessibility.
