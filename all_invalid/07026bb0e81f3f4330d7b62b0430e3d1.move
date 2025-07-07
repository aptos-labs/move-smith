
//# publish
module 0xBADD::TestModule {
    use std::vector;

    // A simple internal function to test internal visibility
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    // Internal data structure with internal visibility
    struct InternalData has key {
        secret_value: u64,
    }

    // Function to initialize internal data
    public fun init_internal_data(s: &signer, val: u64) {
        move_to<InternalData>(s, InternalData { secret_value: val });
    }

    // Function to get internal data (used internally)
    fun get_internal_data(s: &signer): &InternalData {
        borrow_global<InternalData>(signer::address_of(s))
    }

    // Internal function to modify the internal data
    fun update_internal_data(s: &signer, new_val: u64) {
        let data_ref: &mut InternalData = borrow_global_mut<InternalData>(signer::address_of(s));
        data_ref.secret_value = new_val;
    }
}


//# run 0xBADD::entry_point_with_invoke
script {
    fun main(s: &signer): u64 {
        // Call an external function that internally invokes a private function
        0xBADD::call_internal_add(s, 10, 20)
    }

    public fun call_internal_add(s: &signer, a: u64, b: u64): u64 {
        // Internal function is private, so from outside, we call this wrapper
        0xBADD::internal_add(a, b)
    }
}


//# run 0xBADD::variable_scope_test
script {
    fun main(s: &signer): u64 {
        let outer_var = 100;
        let inner_var = 0;

        while (outer_var > 90) {
            let outer_var = outer_var - 1; // Shadow outer variable
            inner_var = inner_var + outer_var; // Inner variable modified inside loop
        };
        // After loop, outer_var outside should remain unchanged (i.e., 100)
        // inner_var reflects last update inside loop
        // No shadowed variable remains outside the loop
        // Assertion for outer_var to compare
        assert!(outer_var == 100, 1);
        // Assertion for inner_var to check last value (which should be sum of last loop iteration)
        assert!(inner_var > 0, 2);
        inner_var
    }
}


//# publish
module 0xINTERNAL::VisibilityTest {
    // A struct with internal visibility
    struct InternalSecret has key {
        value: u64,
    }

    // Internal function accessible only within the module
    fun secret_function(x: u64): u64 {
        x * 2
    }
}


//# run 0xINTERNAL::VisibilityTest::test_internal_access
script {
    fun main(s: &signer): u64 {
        // Instantiate InternalSecret
        let secret = InternalSecret { value: 42 };
        move_to<InternalSecret>(s, secret);
        // Attempt to call internal function directly - should be inaccessible from outside
        // but here, since it's private, direct call would be invalid.
        // Instead, internally call the internal function via wrapper
        0xINTERNAL::VisibilityTest::secret_function(21)
    }
}

// The above script should compile and run successfully, implying internal function access is controlled correctly.
// The attempt to access internal data or functions directly from outside the module should fail, which is expected.


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
