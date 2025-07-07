
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;

    // Internal-only resource to simulate internal visibilities
    struct InternalResource has store, key {
        secret_value: u64,
        visible_value: u64,
    }

    // External script entry point creating and manipulating resource
    public fun create_internal_resource(s: signer, val: u64) {
        move_to<InternalResource>(&s, InternalResource { secret_value: val, visible_value: val });
    }

    // Internal function, accessible within module
    fun update_secret_value(r_ref: &mut InternalResource, new_val: u64) {
        r_ref.secret_value = new_val;
    }

    // Internal function, accessible within module
    fun get_secret_value(r_ref: &InternalResource): u64 {
        r_ref.secret_value
    }

    // Protected access simulated via public functions
    public fun access_visible_value(s: signer): u64 {
        let r_ref: &InternalResource = borrow_global<InternalResource>(signer::address_of(&s));
        r_ref.visible_value
    }

    // Internal only, cannot be called outside
    fun internal_increment_visible(s: signer) {
        let r_ref: &mut InternalResource = borrow_global_mut<InternalResource>(signer::address_of(&s));
        r_ref.visible_value = r_ref.visible_value + 1;
    }

    // Entry point for internal increment
    public fun increment_visible(s: signer) {
        internal_increment_visible(s)
    }
}


//# run 0xCAFE::InteractionTest::create_internal_resource --signers 0xBADD --args 42


//# run 0xCAFE::InteractionTest::access_visible_value --signers 0xBADD


//# run 0xCAFE::InteractionTest::increment_visible --signers 0xBADD


//# run 0xCAFE::InteractionTest::access_visible_value --signers 0xBADD


//# run 0xCAFE::InteractionTest::update_secret_value;  // Trying to call internal function - should fail if outside module


//# run 0xCAFE::InteractionTest::get_secret_value --signers 0xBADD


// Test scenario 1: Multiple script entry points invoking internal functions and verifying behavior

//# run
script {
    fun test_internal_visibility(s: signer) {
        // Create resource
        create_internal_resource(s, 100);
        // Access visible value
        let value = access_visible_value(s);
        assert!(value == 100, 999);
        // Increment visible value
        increment_visible(s);
        let new_value = access_visible_value(s);
        assert!(new_value == 101, 999);
    }
    // Call the test
    test_internal_visibility(@0xBADD);
}


// Test scenario 2: Variable scoping and shadowing and correctness inside while loop

//# run
script {
    fun scoping_shadowing(s: signer) {
        // Declare outer variable
        let outer_var = 10;
        let inside_var = outer_var;

        let counter = 0;

        while (counter < 3) {
            // Shadow variable inside block
            let inside_var = inside_var + 1;
            // Use shadowed variable
            assert!(inside_var == outer_var + (counter + 1), 888);
            // Also assign to outer variable to test mutation
            if (counter == 0) {
                inside_var = 20; // shadowed, mutation shouldn't affect outer
            }
            // At end of iteration, check that outer variable is unchanged
            assert!(outer_var == 10, 999);
            // Increment counter
        }
    }
    // Call the test
    scoping_shadowing(@0xBADD);
}


// Test scenario 3: Variable management outside and inside nested blocks and loops, verifying values after iterations

//# run
script {
    fun complex_variable_flow(s: signer) {
        let outer_x = 5;
        let outer_y = 10;

        // Shadowed inside while
        let i = 0;
        while (i < 2) {
            // Shadow inside block
            let inner_x = outer_x + i;
            // Modify outside vars
            outer_y = outer_y + inner_x;
            // Shadowed variable
            let outer_x = inner_x * 2;
            // Verify shadowed variable
            assert!(outer_x == (outer_x), 777);
            // Next iteration
            i = i + 1;
        }
        // After loop, outer_x should remain unchanged
        assert!(outer_x == 5, 888);
        // outer_y should reflect updates
        assert!(outer_y >= 10, 999);
    }
    // Call the test
    complex_variable_flow(@0xBADD);
}


// Test scenario 4: Functions with internal visibility invoked from scripts, especially functions that do not modify state

//# run
script {
    fun internal_only_function() {
        // internal code, e.g., returning a constant
        let _ = 1234u64;
    }

    // From outside, trying to call internal_only_function() should fail
    // But within the same module, it is allowed

    // Call internal function from script, allowed since in same module
    fun call_internal(s: signer) {
        internal_only_function();
    }

    // Run the inner call
    call_internal(@0xBADD);
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
