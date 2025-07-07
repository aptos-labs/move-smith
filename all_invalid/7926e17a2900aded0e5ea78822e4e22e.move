
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use std::assert;

    // Internal resource with attribute
    @internal
    struct InternalResource has key, store {
        value: u64,
    }

    // Public resource
    struct PublicResource has key, store {
        counter: u64,
    }

    // Internal function with attribute
    @internal
    fun internal_helper(x: u64): u64 {
        x * 2
    }

    // Public function to create and store InternalResource
    public fun create_internal_resource(s: &signer, v: u64) {
        move_to<InternalResource>(s, InternalResource { value: v });
    }

    // Public function to access internal resource (should be accessible internally only)
    public fun get_internal_resource(s: &signer): u64 {
        let resource_ref: &InternalResource = borrow_global<InternalResource>(signer::address_of(s));
        resource_ref.value
    }

    // Public script entry point that calls internal helper
    public fun script_entry_for_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Operation: create public resource
    public fun init_public_resource(s: &signer) {
        move_to<PublicResource>(s, PublicResource { counter: 0 });
    }

    // Operation: increment counter in public resource
    public fun increment_counter(s: &signer) {
        let resource_ref: &mut PublicResource = borrow_global_mut<PublicResource>(signer::address_of(s));
        resource_ref.counter = resource_ref.counter + 1;
    }

    // Access to internal resource limited to modules
    // This function is public but only for internal testing
    public fun get_public_counter(s: &signer): u64 {
        let resource_ref: &PublicResource = borrow_global<PublicResource>(signer::address_of(s));
        resource_ref.counter
    }

    // Function that attempts to access internal resource from outside (should be blocked)
    // This function simulates an invalid external access (this code will compile, but in real tests,
    // attempting access to internal items should be restricted, so here it's a conceptual demonstration.)
    // For the purpose of this test, assume that attempting to access internal resource from an external module
    // is not allowed, so we don't expose this function outside.
    fun attempt_external_internal_access(s: &signer) {
        // Should fail if called from outside in actual environment,
        // but Move compiler won't enforce this statically.
        // So, for the test, just define it but do not invoke externally.
        let _ = borrow_global<InternalResource>(signer::address_of(s));
    }

    // Script function: test variable assignment and shadowing inside while loop
    public fun variable_shadowing_and_iteration(s: &signer): u64 {
        let outer_var: u64 = 0;
        let i: u64 = 0;

        while (i < 5) {
            let outer_var = outer_var + i; // shadow outer_var
            // Update outer_var outside loop to see if outer version remains unchanged
            outer_var
            i = i + 1;
        };
        outer_var // return value, should be sum of 0+1+2+3+4=10
    }

    // Script function: test variable preservation after loop
    public fun verify_post_loop(s: &signer): (u64, u64) {
        let x: u64 = 0;
        let y: u64 = 100;

        let count: u64 = 0;

        while (count < 3) {
            x = x + count; // accumulate sum
            y = y - count; // decrement y
            count = count + 1;
        };
        (x, y)
    }
}


//# run 0xCAFE::TestInteraction::script_entry_for_internal_helper --args 42u64


//# run 0xCAFE::TestInteraction::variable_shadowing_and_iteration --args 0u8


//# run 0xCAFE::TestInteraction::verify_post_loop --args 0u8


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 16552cf62a22ee17fa86d443b203fabd: Annotate Move items with named attributes.
