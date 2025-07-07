
//# publish
module 0xBADD::TestInteraction {
    use std::signer;

    // Internal resource to test internal visibility
    struct InternalResource {
        value: u64,
    }

    // Internal functions are restricted in Move; 'internal' visibility is not supported.
    // To simulate internal access control, we can define functions as private (no 'public' keyword)

    // Private function to initialize internal resource
    fun init_internal_resource(s: &signer, val: u64) {
        move_to<InternalResource>(s, InternalResource { value: val });
    }

    // Public entry script to initialize internal resource
    public fun init_resource(s: &signer, val: u64) {
        init_internal_resource(s, val);
    }

    // Private function to get internal resource value (simulate access restriction)
    fun get_internal_value(s: &signer): u64 acquires InternalResource {
        let resource_ref: &InternalResource = borrow_global<InternalResource>(signer::address_of(s));
        resource_ref.value
    }

    // Script to read internal resource value
    public fun read_internal_value(s: &signer): u64 acquires InternalResource {
        get_internal_value(s)
    }

    // Script with complex control flow: assign, update variables in loops
    public fun complex_control_flow(s: &signer, start: u64): u64 {
        let sum = 0u64;

        // Shadow variable inside while loop for summation
        let i = start;

        while (i < start + 5) {
            // Shadowing sum with a new variable
            let shadow_sum = sum;
            // sum should accumulate
            sum = shadow_sum + i;
            // increment i
            i = i + 1;
        };

        // After loop, confirm sum
        sum
    }

    // Script with variable shadowing and verifying previous values
    public fun variable_shadowing(s: &signer) {
        let x = 10u64;

        // Shadow x in inner scope
        let x = x + 5;
        // The outer x remains 10; inner x is 15
        let _ = x;

        // Some internal variable
        let y = 20u64;
        let y = y + 10;

        // Confirm y is modified (though not returned, just for testing)
        y;
    }

    // Internal functions to test access control
    // 'internal' keyword is not valid in Move; instead, keep functions private (no 'public')
    fun should_not_access_external() {
        // Cannot be called outside the module
    }
}



//# run 0xBADD::TestInteraction::init_resource --signers 0xC0FF --args 42u64


//# run 0xBADD::TestInteraction::read_internal_value --signers 0xC0FF


//# run 0xBADD::TestInteraction::complex_control_flow --signers 0xC0FF --args 100u64


//# run 0xBADD::TestInteraction::variable_shadowing --signers 0xC0FF

// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package. (Simulated by keeping functions private)
// b756742341550e0687aff6514d5b00af: Organize script-related logic within a structured context for processing.
