
//# publish
module 0xDEAD::TestModule {
    use std::debug;

    // Internal resource, only accessible within this module
    struct Counter {
        count: u64,
    }

    // Internal function to initialize Counter resource
    internal fun init_counter(account: &signer): Counter {
        Counter { count: 0 }
    }

    // Internal function to increment count
    internal fun increment(counter: &mut Counter) {
        counter.count = counter.count + 1;
    }

    // Internal function for cross-module call test
    internal fun get_counter_value(counter: &Counter): u64 {
        counter.count
    }

    // Internal helper that does variable manipulation with shadowing
    internal fun shadow_variable(x: u64): u64 {
        let x = x + 10; // shadow outer variable
        x
    }

    // Script entry function to test variable assignments, loops, internal calls, shadowing
    public entry fun run_tests(s: &signer) {
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
            while (inner_var < 5) {
                // Mutate inner_var
                inner_var = inner_var + 1;
            };
            // After inner loop, inner_var should be 5
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


//# run 0xDEAD::TestModule::run_tests --signers 0xBADD --args


//# publish
module 0xBADD::CrossRefTester {
    use 0xDEAD::TestModule;

    // A wrapper that calls internal function via imported wildcard pattern
    public fun call_internal_shadow(x: u64): u64 {
        // Attempt to call internal function in TestModule (should be accessible within the same module)
        // As functions are internal, only methods within the same module can call directly
        // But to test cross-module call with pattern, use the public wrapper
        // Actually, no access outside module, so test cross referencing pattern
        // Here, simulate calling the shadow_variable by importing via pattern
        TestModule::shadow_variable(x)
    }

    // Script entry to run cross module internal calls through wrappers
    public entry fun execute_cross_refs(s: &signer) {
        // Call internal shadow function through wrapper
        let result = call_internal_shadow(55);
        debug::print(&b"Result from shadow_variable:", &result);
    }
}


//# run 0xBADD::CrossRefTester::execute_cross_refs --signers 0xABCD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// b95621755f669bd095d3a95074ab01d4: Use wildcards in identifier positions where allowed, supporting flexible matching or referencing in paths such as addr::Module::*.
