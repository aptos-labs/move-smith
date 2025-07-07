
//# publish
module 0xCAFE::TestModule {

    // Use std for vector and signers
    use std::signer;
    use std::vector;

    // Internal resource for internal function access control test
    struct InternalResource {
        value: u64,
    }

    // Resource with acquire declaration
    struct UniqueResource {
        owner: address,
        data: u64,
    }

    // Publish resource in global storage
    public fun publish_resource(s: signer, data: u64) {
        move_to<UniqueResource>(&s, UniqueResource { owner: signer::address_of(&s), data });
    }

    // Internal function: should be callable inside the module
    fun internal_helper(x: u64): u64 {
        x + 42
    }

    // External function attempting to call internal helper - should fail if called from outside
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Function to acquire resource, expecting it to be available
    public fun get_resource(s: signer): u64 acquires UniqueResource {
        let resource_ref: &UniqueResource = borrow_global<UniqueResource>(signer::address_of(&s));
        resource_ref.data
    }

    // Function to modify resource data
    public fun update_resource(s: signer, new_data: u64) acquires UniqueResource {
        let resource_mut: &mut UniqueResource = borrow_global_mut<UniqueResource>(signer::address_of(&s));
        resource_mut.data = new_data;
    }

    // Entry point scripts: define public functions for script tests
    public fun script_entry_point(x: u8): u8 {
        let counter = 0u8;
        while (counter < x) {
            counter = counter + 1;
        };
        counter
    }

    public fun script_with_shadowed_vars(limit: u8): u8 {
        let a = 10u8;
        let a_counter = 0u8;
        while (a_counter < limit) {
            // shadow 'a' inside loop
            let a = a + a_counter;
            a_counter = a_counter + 1;
        };
        a
    }

    public fun access_internal_and_resource(s: &signer, new_value: u64): u64 {
        // Call internal function - should work inside module
        let val = internal_helper(new_value);

        // Access resource - should work if resource is published
        get_resource(*s) + val
    }

    // Function to acquire resource, for testing acquire usage
    public fun acquire_and_modify(s: signer, new_data: u64): u64 acquires UniqueResource {
        update_resource(s, new_data);
        get_resource(s)
    }

    // Helper runner functions for tests that take no args
    public fun run_entry_point() : u8 {
//# run
        script_entry_point(5u8)
    }

    public fun run_shadowed_vars() : u8 {
//# run
        script_with_shadowed_vars(5u8)
    }

    pub fun run_access_internal() : u64 {
        let dummy_signer: signer = signer::specifier_only;
        access_internal_and_resource(&dummy_signer, 100)
    }
}


//# run 0xCAFE::TestModule::run_entry_point --args 5u8

//# run 0xCAFE::TestModule::run_shadowed_vars --args 5u8

//# run 0xCAFE::TestModule::run_access_internal


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8b5e56f2a902ae0e74b371f98054234c: Verify the proper use of acquires declarations in Move modules and functions
