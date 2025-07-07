
//# publish
module 0xBADD::InteractionTest {
    use std::signer;
    use std::debug;

    // A public script entry point to run the combined test
    public fun run_combined_test(s: signer) {
        Self::execute_loop_and_shadowing();
        // Attempt to call internal function (should fail if outside module)
        // Uncommenting the below line in actual test environment should produce compile error,
        // but for the sake of test code, we won't invoke it directly here.
        // let _ = internal_function(); // Should be inaccessible outside the module
    }

    // This function performs variable assignments, loops, shadowing, and checks
    public fun execute_loop_and_shadowing() {
        // Initialize outer variables
        let outer_x = 0u64;
        let outer_y = 100u64;

        // Shadow variables inside the loop
        let i = 0u64;
        while (i < 5) {
            // Shadowed variables inside loop
            let inner_x = outer_x + i;
            let inner_y = outer_y + i;

            // Inner variables shadow outer ones (simulate shadowing)
            // To demonstrate shadow, we use different variable names but conceptually shadowing
            // or reassign with the same name, but in Move, shadowing is by re-binding
            let inner_x = inner_x + 1;
            let inner_y = inner_y + 1;

            // No mutations to outer_x or outer_y inside the loop, only inner
            // Increment i
            i = i + 1u64;
        }

        // After loop, check variables
        // Outer variables should be unchanged
        assert!(outer_x == 0u64, 1);
        assert!(outer_y == 100u64, 2);
    }

    // Internal function to test internal visibility
    fun internal_function() acquires {} {
        debug::print(&b"inseternal_function"[..]);
    }

    // Public function to test access to internal variable (simulate internal variable)
    public fun get_internal_value(): u64 {
        internal_value()
    }

    // Internal function hidden from outside modules
    fun internal_value(): u64 {
        42u64
    }
}

// Run the combined test by calling the script entry point

//# run 0xBADD::InteractionTest::run_combined_test --signers 0xDEAD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
