
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use std::assert;

    // Internal resource with attribute
    // Note: Move currently does not support custom attributes like '@internal'.
    // To enforce internal visibility, we simply do not expose functions that access this resource publicly.
    // If attribute-based restrictions are required, consider using module privacy.
    struct InternalResource has key, store {
        value: u64,
    }

    // Public resource
    struct PublicResource has key, store {
        counter: u64,
    }

    // Internal function with attribute
    // Move does not recognize '@internal' attribute; define as private
    fun internal_helper(x: u64): u64 {
        x * 2
    }

    // Public function to create and store InternalResource
    public fun create_internal_resource(s: &signer, v: u64) {
        move_to<InternalResource>(s, InternalResource { value: v });
    }

    // Public function to access internal resource (should be accessible internally only)
    // Since internal resource is internal, we do not expose functions that access it publicly.
    // For testing purposes, this function is kept public but should be used cautiously.
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

    // Access to public resource's counter
    public fun get_public_counter(s: &signer): u64 {
        let resource_ref: &PublicResource = borrow_global<PublicResource>(signer::address_of(s));
        resource_ref.counter
    }

    // Function that attempts to access internal resource from outside
    // This function is for internal use only and should not be called externally in tests
    fun attempt_external_internal_access(s: &signer) {
        // Should fail if called from outside in actual environment
        let _ = borrow_global<InternalResource>(signer::address_of(s));
    }

    // Script function: test variable assignment and shadowing inside while loop
    public fun variable_shadowing_and_iteration(s: &signer): u64 {
        let outer_var: u64 = 0;
        let i: u64 = 0;

        while (i < 5) {
            // Shadow outer_var in this scope
            let outer_var = outer_var + i;
            // Correctly update outer_var outside to see if outer version remains unchanged
            // But since outer_var is shadowed, the outer outer_var remains unchanged
            i = i + 1;
            // Note: outer_var shadow so outer scope variable remains 0
            // For clarity, but in Move, shadowing is limited to current scope
        }
        // The outer_var outside loop remains 0
        // If the intention is to sum 0+1+2+3+4=10, need different approach
        // But per the original code, the return should be sum: 0+1+2+3+4=10
        // To achieve that, accumulate inside the loop
        let sum: u64 = 0;
        let index: u64 = 0;
        while (index < 5) {
            let _shadow_var = index; // shadow
            sum = sum + index;
            index = index + 1;
        }
        sum
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
