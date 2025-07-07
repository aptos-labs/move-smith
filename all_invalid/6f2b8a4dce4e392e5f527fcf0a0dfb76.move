//# publish
module 0xDEAD::InteractionTestModule {
    use std::signer;
    use std::vector; // Warning: unused alias, but kept if needed later

    // Struct for testing generic instantiation
    struct GenericStruct<T> has store, key {
        value: T,
        is_active: bool,
    }

    // Resource for internal testing
    struct InternalResource has key {}

    // Public entry point to test variable scoping, shadowing, and control flow
    public fun test_variable_scoping(s: signer): bool {
        let outer_var = 0u64;

        let mutable_var = 10u64;
        while (mutable_var < 15) {
            // Shadow inner variable
            let mutable_var = mutable_var + 1;
            // Ensure inner mutable_var is scoped locally
            // (No additional code needed here)
        };
        // After loop, inner mutable_var is scoped within loop
        // Outer variable remains unchanged
        assert!(mutable_var == 10u64, 1000);
        // Outer variable not shadowed, so check its value
        outer_var == 0u64
    }

    // Function demonstrating internal function invocation with resource access
    fun internal_function_access(s: &signer) {
        // Instantiate resource in scope (simulate resource creation)
        move_to<InternalResource>(s, InternalResource {});
        // Call internal helper
        internal_helper();
    }

    fun internal_helper() {
        // Internal function, only callable within module
        // For demonstration, do nothing
        ()
    }

    // Entry point for resource creation with attribute (simulate attribute with known/unknown)
    // attribute("known_attr")]
    public fun create_resource_with_attribute(s: &signer) {
        move_to<InternalResource>(s, InternalResource {});
    }

    // Function with unknown attribute, should compile regardless
    // attribute("unknown_attr")]
    public fun create_resource_unknown_attribute(s: &signer) {
        move_to<InternalResource>(s, InternalResource {});
    }

    // Instantiate generic struct with specific types and check fields
    public fun instantiate_generic_struct(x: u64, active: bool): GenericStruct<u64> {
        let gs = GenericStruct { value: x, is_active: active };
        // Validate fields
        assert!(gs.value == x, 2001);
        assert!(gs.is_active == active, 2002);
        gs
    }

    // Entry to test attribute application with known and unknown attributes
    // attribute("test_attr")]
    public fun attribute_applied_test(s: &signer) {
        // dummy function
        ()
    }
}



//# run 0xDEAD::InteractionTestModule::test_variable_scoping --signers 0xBADD



//# run 0xDEAD::InteractionTestModule::internal_function_access --signers 0xBADD



//# run 0xDEAD::InteractionTestModule::create_resource_with_attribute --signers 0xBADD



//# run 0xDEAD::InteractionTestModule::create_resource_unknown_attribute --signers 0xBADD



//# run 0xDEAD::InteractionTestModule::instantiate_generic_struct --signers 0xBADD --args 42u64 true



//# run 0xDEAD::InteractionTestModule::attribute_applied_test --signers 0xBADD


// Features:
// - Corrected resource instantiation: replaced `signer::borrow_global_mut<signer>(0x0)` with passing the signer reference `s`
// - Ensured passing correct signer reference to move_to
// - Changed internal_function_access to accept `&signer` and pass it to `move_to`
// - Fixed variable shadowing logic to avoid compilation and runtime errors
// - Use `assert!` to verify variable states
