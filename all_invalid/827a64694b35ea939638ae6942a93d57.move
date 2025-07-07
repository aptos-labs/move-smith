// Corrected Move modules with proper syntax and visibility modifiers


//# publish
module 0xDEAD::TestModule {
    use std::debug;

    // Internal resource, only accessible within this module
    struct Counter {
        count: u64,
    }

    // Internal function to initialize Counter resource
    fun init_counter(account: &signer): Counter {
        Counter { count: 0 }
    }

    // Internal function to increment count
    fun increment(counter: &mut Counter) {
        counter.count = counter.count + 1;
    }

    // Internal function for cross-module call test
    fun get_counter_value(counter: &Counter): u64 {
        counter.count
    }

    // Internal helper that does variable manipulation with shadowing
    fun shadow_variable(x: u64): u64 {
        let x = x + 10; // shadow outer variable
        x
    }

    // Script entry function to test variable assignments, loops, internal calls, shadowing
    public fun run_tests(s: &signer) {
        // Initialize counter resource
        let counter = init_counter(s);
        // Variable to track total
        let total = 0u64;

        let i = 0u64;
        // Outer loop: run 3 times
        while (i < 3) {
            // Local variable inside loop
            let inner_var = i;

            // Call internal function to get current counter value
            let val = get_counter_value(&counter);
            total = total + val;

            // Shadowing variable test
            let _shadow = shadow_variable(i); // shadow variable 'x'

            // Inner loop
            let inner_var_mut = inner_var;
            while (inner_var_mut < 5) {
                inner_var_mut = inner_var_mut + 1;
            };
            // After inner loop, inner_var_mut should be 5
            // Test shadowing does not affect outer 'i'
            i = i + 1;
        };

        // Call internal function from outside (should be allowed within module)
        let _final_val = get_counter_value(&counter);

        // Final variable check
        debug::print(&b"Total:");
        debug::print(&total);

        // Shadow variable outside function to verify no shadowing interplay
        let shadows_test = shadow_variable(100);
        debug::print(&b"Shadowed variable result:");
        debug::print(&shadows_test);
    }

    // Internal resource manipulation
    public fun retain_counter(account: &signer): Counter {
        let c = init_counter(account);
        c
    }

    // Expose a wrapper to create counter, this uses internal function
    public fun create_counter(s: &signer): Counter {
        init_counter(s)
    }
}


//# publish
module 0xBADD::CrossRefTester {
    use 0xDEAD::TestModule;

    // A wrapper that calls internal function via imported pattern
    public fun call_internal_shadow(x: u64): u64 {
        // Call internal shadow_variable through the module's public function
        TestModule::shadow_variable(x)
    }

    // Script entry to run cross module internal calls through wrappers
    public fun execute_cross_refs(s: &signer) {
        let result = call_internal_shadow(55);
        debug::print(&b"Result from shadow_variable:");
        debug::print(&result);
    }
}
