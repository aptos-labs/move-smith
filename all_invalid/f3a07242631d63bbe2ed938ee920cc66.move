//# publish
module 0xC0FFEE::InteractionTest {
    use std::signer;
    use std::debug;

    // Internal variable declared as a module constant; Move does not support 'var' at module scope.
    // Instead, we use a resource or a stored singleton, but for test simplicity, we can simulate using a static resource.
    // For testing, we'll define a resource to hold internal state.

    // Define a resource to hold internal state
    struct InternalState has key {
        value: u64,
    }

    // Initialize internal state in a persistent storage
    public fun initialize_state() {
        if (!exists<InternalState>(@0xC0FFEE)) {
            move_to(@0xC0FFEE, &mut InternalState { value: 0 });
        }
    }

    // Internal function to modify internal_var (simulated via resource)
    fun internal_increment() {
        // Access the resource
        let state_ref = borrow_global_mut<InternalState>(@0xC0FFEE);
        state_ref.value = state_ref.value + 1;
    }

    // Public script entry point to invoke internal functions
    public fun initialize_and_increment(signer_addr: address) {
        // Initialize state if not already initialized
        initialize_state();
        let s = signer::new_signer(signer_addr);
        // Call internal function
        internal_increment();
        // After increment, internal_var should be 1
        let state_ref = borrow_global<InternalState>(@0xC0FFEE);
        assert!(state_ref.value == 1, 100);
    }

    // Internal function that performs nested variable handling and shadowing
    fun variable_shadowing_logic() {
        let outer_var: u64 = 10;
        // Shadow outer_var with inner declaration inside a block
        {
            let outer_var: u64 = 20; // shadow
            // Inside this block, outer_var should be 20
            assert!(outer_var == 20, 101);
        }
        // Outside block, outer_var should be original 10
        assert!(outer_var == 10, 102);
    }

    // Function to test variable handling inside a while loop
    public fun variable_handling_in_loop() {
        let count: u64 = 0;
        let sum: u64 = 0;
        while (count < 5) {
            // Declare a variable inside loop
            let inner_var: u64 = count * 2;
            // Reassign count and sum
            count = count + 1;
            sum = sum + inner_var;
            // Assert inner_var is correct
            assert!(inner_var == (count - 1) * 2, 103);
        };
        // After loop, verify count and sum
        assert!(count == 5, 104);
        // sum should be 0+2+4+6+8=20
        assert!(sum == 20, 105);
    }

    // Function to test variable declaration outside and inside loop, and reassignment
    public fun variables_outside_inside_loop() {
        let total: u64 = 0;
        let loop_var: u64 = 0;
        while (loop_var < 3) {
            // Shadow with inner variable
            {
                let inner_loop_var: u64 = loop_var + 1; // shadow inside block
                total = total + inner_loop_var;
                // inner_loop_var should be loop_var+1
                assert!(inner_loop_var <= 3, 106);
            }
            // Reassign outer loop_var
            loop_var = loop_var + 1;
        };
        // After loop, total should be 1+2+3=6
        assert!(total == 6, 107);
    }

    // Function to attempt external access to internal variables/ functions
    public fun external_access_attempt() {
        // Attempt to call internal function - external calls outside module should fail,
        // but internally it's allowed
        internal_increment();
        // Assert internal_var incremented
        let state_ref = borrow_global<InternalState>(@0xC0FFEE);
        assert!(state_ref.value == 1, 108);
        // Direct access to internal state variable is through resource, which is internal
        // Attempt to access resource from outside module would fail (simulate)
        // External code cannot access InternalState directly, so no code needed here
    }
}

// The run directives remain the same; no changes needed, just ensure you call the correct functions.
