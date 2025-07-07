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

//# run 0xCAFE::InteractionTest::update_secret_value --signers 0xBADD --args 999 // Trying to call internal function - should compile but fail at runtime if called externally

//# run 0xCAFE::InteractionTest::get_secret_value --signers 0xBADD

// Test scenario 1: Multiple script entry points invoking internal functions and verifying behavior
// Note: The following scripts should be run separately as scripts, not in one batch

// Script: test_internal_visibility.move
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
    fun main(s: &signer) {
        test_internal_visibility(*s);
    }
}

// Script: scoping_shadowing.move
//# run
script {
    fun scoping_shadowing(s: signer) {
        // Declare outer variable
        let outer_var = 10;
        let inside_var = outer_var;

        let counter = 0;
        while (counter < 3) {
            // Shadow variable inside block
            let inside_var_shadow = inside_var + 1;
            // Use shadowed variable
            assert!(inside_var_shadow == outer_var + (counter + 1), 888);
            // Also assign to outer variable to test mutation
            if (counter == 0) {
                inside_var_shadow = 20; // shadowed, mutation shouldn't affect outer
            }
            // Outer variable remains unchanged
            assert!(outer_var == 10, 999);
            // Increment counter
            counter = counter + 1;
        }
    }
    fun main(s: &signer) {
        scoping_shadowing(*s);
    }
}

// Script: complex_variable_flow.move
//# run
script {
    fun complex_variable_flow(s: signer) {
        let outer_x = 5;
        let outer_y = 10;
        let i = 0;

        while (i < 2) {
            // Shadow inside block
            let inner_x = outer_x + i;
            // Modify outside vars
            outer_y = outer_y + inner_x;
            // Shadowed variable; create a new variable
            let outer_x_shadow = inner_x * 2;

            // Verify shadowed variable
            assert!(outer_x_shadow == inner_x * 2, 777);
            // Next iteration
            i = i + 1;
            // Update outer_x for next loop if needed
            // (In the original, outer_x remains unchanged, so no reassignment)
        }
        // After loop, check outer_x remains the same
        assert!(outer_x == 5, 888);
        // outer_y should have been updated accordingly
        assert!(outer_y >= 10, 999);
    }
    fun main(s: &signer) {
        complex_variable_flow(*s);
    }
}

// Script: internal_only_function.move
//# run
script {
    fun internal_only_function() {
        // internal code, e.g., returning a constant
        let _ = 1234u64;
    }

    fun call_internal(s: &signer) {
        internal_only_function()
    }

    fun main(s: &signer) {
        call_internal(s);
    }
}
