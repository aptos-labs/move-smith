
//# publish
module 0xCAFE::ComplexInteractionTest {
    use std::vector;

    // Internal function, which should NOT be accessible outside
    fun internal_increment(x: u64): u64 {
        x + 1
    }

    // Public entry point to invoke internal functions and run tests
    public fun run_all_tests() {
        call_internal_increment(5u64);
        test_variable_shadowing_in_loop();
        test_nested_if_continue();
    }

    // Try to call an internal function from outside - should fail to compile
    // (Commented out as it would block compilation, but included for illustration)
    // public fun external_call() {
    //     internal_increment(10u64);
    // }

    // Function to call a private internal function
    public fun call_internal_increment(val: u64): u64 {
        internal_increment(val)
    }

    // Test variable declaration, modification inside a while loop, and shadowing
    fun test_variable_shadowing_in_loop() {
        let counter: u64 = 0;
        let shadow_var: u64 = 100;

        while (counter < 5) {
            let shadow_var = shadow_var + counter; // shadow original shadow_var
            shadow_var = shadow_var * 2;          // mutable re-assignment
            counter = counter + 1;
        };

        // After loop: shadow_var should be (initial 100 + sum(0..4)) * 2
        // sum(0..4) = 0+1+2+3+4=10
        // shadow_var = (100 + 10) * 2 = 220
        assert!(shadow_var == 220, 999);
        assert!(counter == 5, 999);
    }

    // Test nested if statements with continue inside outer loop
    fun test_nested_if_continue() {
        let sum: u64 = 0;
        let i: u64 = 0;

        while (i < 10) {
            if (i % 2 == 0) {
                if (i == 4) {
                    i = i + 1; // to avoid infinite loop
                    continue;
                }
                // for even i, skip adding
                i = i + 1;
                continue;
            } else {
                // odd i: add to sum
                sum = sum + i;
                i = i + 1;
            };
            // To confirm break condition when i hits 8 (for example)
            if (i >= 8) {
                break;
            }
        };

        // i should be at least 8 (since loop breaks when i>=8)
        // sum should include values 1,3,5,7
        assert!(sum == 1 + 3 + 5 + 7, 999);
        assert!(i >= 8, 999);
    }
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
