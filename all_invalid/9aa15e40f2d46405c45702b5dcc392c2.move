
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

// Corrected is to define the entry point without the 'entry_point_with_invoke' module prefix as part of the script.



//# run 0xBADD::TestModule::main
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
            let outer_var_shadow = outer_var - 1; // Shadow outer variable
            inner_var = inner_var + outer_var_shadow; // Update inner_var
            // Note: shadowed variable is only inner_var_shadow
        }
        // After loop, outer_var outside should remain unchanged (i.e., 100)
        // inner_var reflects last update inside loop
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

// Corrected to reference the module properly

//# run 0xINTERNAL::VisibilityTest::main
script {
    fun main(s: &signer): u64 {
        // Instantiate InternalSecret
        move_to<InternalSecret>(s, InternalSecret { value: 42 });
        // Call internal function via internal wrapper
        0xINTERNAL::VisibilityTest::secret_function(21)
    }
}
