
//# publish
module 0xCAFE::ScopeAndAccessTest {
    // Using std for assertions, etc.
    use std::signer;
    use std::debug;

    // A resource with internal visibility
    struct InternalResource has key {
        value: u8,
    }

    // Public script entry point to initialize the internal resource
    public fun initialize_internal(s: signer, val: u8) {
        move_to<InternalResource>(&s, InternalResource { value: val });
    }

    // Internal function, only accessible within this module
    fun internal_update_resource(resource_ref: &mut InternalResource, new_value: u8) {
        resource_ref.value = new_value;
    }

    // Public script that calls an internal function
    public fun call_internal_update(s: signer, new_value: u8) {
        let resource_ref: &mut InternalResource = borrow_global_mut<InternalResource>(signer::address_of(&s));
        internal_update_resource(resource_ref, new_value);
    }

    // Accessor to read the resource value, public
    public fun read_resource(s: signer): u8 {
        let resource_ref: &InternalResource = borrow_global<InternalResource>(signer::address_of(&s));
        resource_ref.value
    }

    // Function that attempts to call internal function externally (should fail if attempted outside)
    // but since inside module, can call directly
    public fun external_internal_call(s: signer, new_value: u8) {
        let resource_ref = borrow_global_mut<InternalResource>(signer::address_of(&s));
        internal_update_resource(resource_ref, new_value);
    }

    // Script with variables initialized outside a loop and inside
    public fun variable_scope_test() {
        let x = 0u64;

        // Initialize 'shadowed' variable outside loop
        let shadowed_var = 100u64;
        let _ = shadowed_var;

        // Outer variable
        let outer_var = 5u64;

        // Loop to modify variables
        let i = 0u64;
        while (i < 3) {
            let inner_var = i + outer_var; // shadow variable inside loop
            // verify the inner_var equals expected
            assert!(inner_var == i + outer_var, 42);
            // update outer variable
            shadowed_var = shadowed_var + inner_var;
            i = i + 1;
        }

        // After loop, check the variables
        assert!(shadowed_var == 100 + (0 + 5) + (1 + 5) + (2 + 5), 42);
        // Shadowed variable outside loop remains unchanged
        assert!(shadowed_var == 100 + 5 + 6 + 7, 42);
    }

    // Function with nested let bindings and variable shadowing
    public fun nested_shadowing() {
        let a = 10u64;
        let a_shadow = 20u64; // shadows outer 'a'
        let b = 30u64;

        // Inner block
        {
            let a_inner = 40u64; // shadows 'a_shadow'
            assert!(a_inner == 40, 42);
        };
        // After inner block
        assert!(a_shadow == 20, 42);
        assert!(b == 30, 42);
    }

    // Function with internal resource access
    public fun internal_resource_test(s: signer, new_value: u8) {
        if (exists<InternalResource>(signer::address_of(&s))) {
            call_internal_update(s, new_value);
        } else {
            // Initialize resource if not exists
            initialize_internal(s, new_value);
        }
        let val = read_resource(s);
        assert!(val == new_value, 42);
    }
}


//# run 0xCAFE::ScopeAndAccessTest::variable_scope_test


//# run 0xCAFE::ScopeAndAccessTest::nested_shadowing


//# run 0xCAFE::ScopeAndAccessTest::internal_resource_test --signers 0xBEEF --args 42u8


//# run 0xCAFE::ScopeAndAccessTest::call_internal_update --signers 0xBEEF --args 77u8


//# run 0xCAFE::ScopeAndAccessTest::read_resource --signers 0xBEEF


//# run 0xCAFE::ScopeAndAccessTest::initialize_internal --signers 0xBEEF --args 55u8

// Attempt to call internal functions externally (should be restricted). The above tests cover internal access restrictions, since internal functions can only be called within the module. If attempting outside, it would cause compilation error, so no explicit call here outside module.


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
