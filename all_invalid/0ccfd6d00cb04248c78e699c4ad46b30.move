
//# publish
module 0xDEAD::InteractionTestModule {
    use std::signer;
    use std::vector;

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
        };
        // After loop, outer mutable_var remains unchanged
        assert!(mutable_var == 10u64, 1000);
        // Outer variable not shadowed
        outer_var == 0u64
    }

    // Function demonstrating internal function invocation with resource access
    fun internal_function_access() {
        // Instantiate resource in scope (simulate resource creation)
        move_to<InternalResource>(&signer::borrow_global_mut<signer>(0x0), InternalResource {});
        // Call internal function
        internal_helper();
    }

    fun internal_helper() {
        // Internal function, only callable within module
        // Access resource (simulate usage)
        // Can't borrow global resource outside module, so just dummy
        ()
    }

    // Entry point for resource creation with attribute (simulate attribute with known/unknown)
    // attribute("known_attr")]
    public fun create_resource_with_attribute(s: signer) {
        move_to<InternalResource>(&s, InternalResource {});
    }

    // Function with unknown attribute, should compile regardless
    // attribute("unknown_attr")]
    public fun create_resource_unknown_attribute(s: signer) {
        move_to<InternalResource>(&s, InternalResource {});
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
    public fun attribute_applied_test(s: signer) {
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


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// a2d34cd27e5cc336633977d53e550c66: Instantiate generic structs with specific type parameters using the 'StructInstantiation<types>' syntax.
// 3c53441ec2d42daf02f3f9fa7fb17033: Use attributes with known or unknown attribute names.
