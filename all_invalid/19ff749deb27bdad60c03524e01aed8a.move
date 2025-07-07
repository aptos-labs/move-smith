
//# publish
module 0xDEAD::InteractionTestModule {
    use std::signer;
    use std::vector;

    // Internal module state for testing
    struct State has store {
        counter: u64,
        flag: bool,
    }

    public fun init(s: &signer) {
        move_to<State>(signer::address_of(s), State { counter: 0, flag: false });
    }

    // Internal function that should not be callable externally
    fun internal_increment_state(state_ref: &mut State) {
        state_ref.counter = state_ref.counter + 1;
    }

    // Internal function that should not be callable externally
    fun internal_set_flag(state_ref: &mut State, value: bool) {
        state_ref.flag = value;
    }

    // Entry script for testing internal calls and variable manipulations
    public fun script_entry_point(s: &signer) {
        let state_ref: &mut State = borrow_global_mut<State>(signer::address_of(s));
        internal_increment_state(&mut state_ref);
        internal_set_flag(&mut state_ref, true);
    }

    // Helper method to invoke internal functions internally
    public fun run_internal_increases(s: &signer) {
        let state_ref: &mut State = borrow_global_mut<State>(signer::address_of(s));
        internal_increment_state(&mut state_ref);
        internal_set_flag(&mut state_ref, false);
    }
}



//# run 0xDEAD::InteractionTestModule::init --signers 0xBADD



//# run 0xDEAD::InteractionTestModule::script_entry_point --signers 0xBADD

// The above calls initialize state, run internal functions via script, and test internal visibility



//# publish
module 0xC0FF::VariableShadowing {
    // Public entry point to test variable shadowing with loops
    public fun test_shadowing() {
        let outer_var: u64 = 100;
        let shadowed_var: u64 = outer_var;
        let outer_var_outer_scope: u64 = outer_var;

        // First loop: shadow inner variable
        for (i in 0..3) {
            let shadowed_var: u64 = i; // shadowing inner variable
            // Use shadowed_var inside loop
            if (shadowed_var == i) {}
        }

        // After loop, outer_var outer scope should be unchanged
        assert!(outer_var_outer_scope == 100, 999);
        // shadowed_var outside should be unchanged
        assert!(shadowed_var == 100, 998);
    }

    // Function to test assigning variables inside and outside loops and their scopes
    public fun assign_var_in_loop() {
        let count: u64 = 0;
        let outer_counter: u64 = count;

        let temp_var: u64 = 0;
        for (i in 0..5) {
            let temp_var_inner: u64 = i * 2; // shadowed within loop
            temp_var_inner = temp_var_inner + 1; // modify inner temp_var
            count = count + temp_var_inner;
        }
        // After loop, temp_var outside loop is unchanged
        assert!(temp_var == 0, 997);
        // outer_counter retains initial value
        assert!(outer_counter == 0, 996);
        // count accumulates values
        assert!(count == 30, 995);
    }
}



//# run 0xC0FF::VariableShadowing::test_shadowing



//# run 0xC0FF::VariableShadowing::assign_var_in_loop


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
