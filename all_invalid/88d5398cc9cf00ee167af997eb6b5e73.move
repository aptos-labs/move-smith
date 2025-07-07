
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Internal resource with internal visibility
    struct InternalResource {
        value: u64,
    }

    // Public resource for testing
    struct PublicResource {
        counter: u64,
    }

    // Internal function, should only be accessible within the module
    fun internal_increment_resource(res: &mut InternalResource) {
        res.value = res.value + 1;
    }

    // Public function to modify internal resource
    public fun internal_modify(s: signer) {
        let res = borrow_global_mut<InternalResource>(signer::address_of(&s));
        internal_increment_resource(&mut res);
    }

    // External function attempting access to internal function (should work because within same module)
    public fun external_access_internal() {
        let res = InternalResource {value: 0};
        internal_increment_resource(&mut res);
    }

    // Function demonstrating the shadowing behavior with local variables
    public fun shadowing_variables() {
        let outer_var: u64 = 10;
        let inner_var: u64 = 0;

        let i: u64 = 0;
        while (i < 3) {
            let outer_var: u64 = outer_var + i; // shadow outer_var
            let inner_var: u64 = i * 2; // shadow inner_var
            let _ = inner_var; // just to use it
            i = i + 1;
        };
        // after loop, outer_var should still be 10, inner_var is not affected
        outer_var
    }

    // Internal function simulating target environment behavior
    fun target_only_fn() -> u64 {
        42
    }

    // Public function that calls internal target-only function
    public fun call_target_only(): u64 {
        target_only_fn()
    }

    // Governance function for combined internal/resource interactions
    public fun governance_flow(s: signer) {
        // Create and store a public resource
        let pub_res = PublicResource {counter: 0};
        move_to<PublicResource>(&s, pub_res);

        // Call internal function
        internal_modify(s);

        // Access resource after modification
        let res_ref = borrow_global<PublicResource>(signer::address_of(&s));
        let _ = res_ref.counter;

        // Call target only function
        let _ = call_target_only();
    }
}



//# run 0xCAFE::TestModule::shadowing_variables --args
// No args needed for this script



//# run 0xCAFE::TestModule::governance_flow --signers 0xBADD --args


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 32c9e9589dffb8fdc93267425c721b63: Set the environment to treat all code as target code if specified.
