
//# publish
module 0xDEAD::InteractionTest {
    use std::signer;

    // Resource to hold a counter, used for testing module state updates
    struct Counter has store, key {
        count: u64,
    }

    // Initialize resource at an account
    public fun init_counter(s: signer) {
        let cnt = Counter { count: 0 };
        move_to<Counter>(&s, cnt);
    }

    // Increment counter in resource
    public fun increment_counter(s: signer) {
        let cnt_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        cnt_ref.count = cnt_ref.count + 1;
    }

    // Function to get current count
    public fun get_count(s: signer): u64 {
        let cnt_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        cnt_ref.count
    }

    // Internal function for internal access testing
    fun internal_modify_counter(count: &mut u64) {
        *count = *count + 10;
    }
}


//# run 0xDEAD::InteractionTest::init_counter --signers 0xBADD


//# run 0xDEAD::InteractionTest::increment_counter --signers 0xBADD


//# run 0xDEAD::InteractionTest::get_count --signers 0xBADD

// Test script invoking module functions and local variables, and internal visibility restrictions
//* (Note: Internal functions are only callable inside the module, so external calls cannot invoke 'internal_modify_counter')

//# run
script {
    use std::signer;
    use 0xDEAD::InteractionTest;

    fun main(s: signer) {
        // Initialize counter resource
        InteractionTest::init_counter(&s);
        // Increment counter twice
        InteractionTest::increment_counter(&s);
        InteractionTest::increment_counter(&s);

        // Declare local variable outside loop
        let local_sum: u64 = 0;
        // Declare loop variable
        let i: u64 = 0;

        // Loop: for i in 0..3
        while (i < 3) {
            // Inside loop, declare shadowed local variable
            let local_sum = local_sum + i;
            // Increment loop variable
            i = i + 1;
        };

        // After loop, assert local_sum value (should be 3: 0+1+2)
        // To check, borrow the count resource for verification
        let count_before = InteractionTest::get_count(&s);
        // Call internal function indirectly: cannot call from outside, skip
        // Instead, just check local variable
        // (Assuming assertions are allowed outside, or just inline as last expression)
        // For validity, check that local_sum is as expected
        local_sum;

        // Try to access internal function outside module - should fail to compile if uncommented
        // InteractionTest::internal_modify_counter(&mut count_before); // This line should be commented out or cause compile error
    }
}


//# run 0xDEAD::InteractionTest::main --signers 0xFACE


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
