
//# run 0xCAFE::TestInteraction::run_tests



//# publish
module 0xCAFE::TestInteraction {
    use std::signer;

    // This resource is used to test internal visibility restrictions
    struct InternalResource has key {
        value: u64,
    }

    // Public function that invokes internal functions, called by scripts
    public fun execute_inner_functions() {
        internal_function_a();
        internal_function_b(42); // Provide an argument for internal_function_b
        // Create resource inside module using internal visibility
        create_internal_resource(signer::address_of(&signer::borrow_global_or_abort<signer>(&signer::public_signer())));
    }

    // Internal function: should only be callable within this module
    fun internal_function_a() {
        // does something simple
        let _ = 42u64;
    }

    // Internal function with parameters
    fun internal_function_b(x: u64) {
        let _ = x + 1;
    }

    // Internal function that creates a resource; used internally
    fun create_internal_resource(addr: address) {
        let resource = InternalResource { value: 100 };
        move_to<InternalResource>(&signer::borrow_global_mut<signer>(&signer::public_signer()), resource);
    }

    // The script entry point to run the test
    public fun run_tests() {
        // Call functions that invoke internal functions
        execute_inner_functions();

        // Attempt to access internal resource; expected to succeed internally
        let resource_ref: &mut InternalResource = borrow_global_mut<InternalResource>(signer::address_of(&signer::borrow_global<signer>(&signer::public_signer())));
        resource_ref.value = resource_ref.value + 1;

        // Check shadowed variables within a loop
        let outer_var = 0u64;
        let i = 0u64;
        while (i < 3) {
            // shadow inner scope variable
            let inner_var = i;
            // shadow outer variable intentionally
            let outer_var = outer_var + inner_var;
            // inside loop, verify values
            assert!(outer_var == inner_var, 999);
            i = i + 1;
        };
        // outside loop, verify outer variable remains unchanged
        assert!(outer_var == 0u64, 998);
    }
}
