
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;

    struct Counter has store, key {
        value: u64,
    }

    // Internal function, accessible only within this module
    fun internal_increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    // Entry script 1: Calls internal functions and modifies variables
    public fun script_entry_1(s: signer): u64 {
        let addr = signer::address_of(&s);
        let counter = if (exists<Counter>(addr)) {
            borrow_global_mut<Counter>(addr)
        } else {
            move_to<Counter>(&s, Counter { value: 0 });
            borrow_global_mut<Counter>(addr)
        };
        // Local variable declared outside loop
        let local_var: u64 = counter.value;
        // Shadowed variable with same name inside loop
        let local_var_shadowed: u64 = local_var;

        let i: u64 = 0;
        while (i < 3) {
            // Assign to original variable
            local_var = local_var + i;
            // Shadowing local variable within loop
            let local_var_shadowed: u64 = local_var * 2;

            // Call internal function
            internal_increment(&mut counter);
            i = i + 1;
        };
        // After loop, check final value of local_var
        counter.value = local_var; // update counter with last local_var value
        counter.value
    }

    // Entry script 2: Tests variable shadowing and accessibility restrictions
    public fun script_entry_2(s: signer): u64 {
        let addr = signer::address_of(&s);
        // Declare variable with same name as inside previous function
        let shadow_var: u64 = 10;
        // Declare a local variable
        let val: u64 = 5;
        // Shadow the variable
        let shadow_var: u64 = shadow_var + val;
        // Call internal function (should be accessible here)
        // but simulate attempt to call non-existent outside function
        // (simulate attempting to call private/internal function from outside)
        // Note: Can't actually call internal from outside, but ensure that functions
        // labeled internal are not publicly accessible.
        let res = shadow_var + 1;
        res
    }

    // Internal function, attempting access from outside should be invalid
    // but here we just keep it internal
    fun internal_subtract(counter: &mut Counter, delta: u64) {
        counter.value = counter.value.saturating_sub(delta);
    }

    // Internal variable: simulate with internal function only
    fun internal_helper(): u64 {
        42
    }

    // Exposed functions invoke internal functions
    public fun call_internal_helper(s: signer): u64 {
        internal_helper()
    }
}


//# run 0xCAFE::InteractionTest::script_entry_1 --signers 0xBEEF

//# run 0xCAFE::InteractionTest::script_entry_2 --signers 0xBEEF


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
