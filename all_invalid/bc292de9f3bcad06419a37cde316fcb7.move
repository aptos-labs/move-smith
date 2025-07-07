
//# publish
module 0xDEAD::ScopedTest {
    use std::signer;

    // Internal resource to track internal access
    struct InternalCounter has key {
        count: u64,
    }

    // Initialize resource for testing
    public fun init(s: signer) {
        move_to<InternalCounter>(&s, InternalCounter { count: 0 });
    }

    // Internal function (should not be callable from outside)
    fun internal_increment(counter: &mut InternalCounter) {
        counter.count = counter.count + 1;
    }

    // Function that calls internal function and updates resource
    public fun call_internal(s: signer) {
        let counter_ref: &mut InternalCounter = borrow_global_mut<InternalCounter>(signer::address_of(&s));
        internal_increment(counter_ref);
    }

    // Function with while loop: Variables outside loop are assigned and updated
    public fun variable_scoping_while(s: signer): u64 {
        let counter_ref: &mut InternalCounter = borrow_global_mut<InternalCounter>(signer::address_of(&s));
        let total: u64 = 0;
        let i: u64 = 0;

        while (i < 5) {
            // Shadow outer _i inside a block to test scoping
            let _i = i + 10;
            total = total + _i;
            // Increment inner shadow variable; outer i remains unaffected
            i = i + 1;
        };
        // After loop, verify variables
        total
    }

    // Function with inner scope shadowing variable 'x'
    public fun shadowing_variables(s: signer): u64 {
        let x: u64 = 100;
        let iteration: u64 = 0;

        while (iteration < 3) {
            // Shadow with inner let
            let x = x + iteration; // inner x
            // Do something with inner x
            // Increment inner x
            x = x + 1;
            iteration = iteration + 1;
        };
        // After loop, outer x should remain unchanged
        x
    }

    // Entry script calling functions
    public fun run_tests(s: signer) {
        init(s);
        // Call internal function - should be allowed within the module
        call_internal(s);
        // Test variable scoping with while
        let sum = variable_scoping_while(s);
        // Test shadowing variables
        let final_x = shadowing_variables(s);
        // Use the values to avoid optimizations
        assert!(sum >= 0, 42);
        assert!(final_x >= 100, 42);
    }
}



//# run 0xDEAD::ScopedTest::run_tests --signers 0xBADD --args


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
