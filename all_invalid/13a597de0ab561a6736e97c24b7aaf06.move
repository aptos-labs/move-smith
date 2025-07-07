module 0xCAFE::AssertTest {
    use std::vector;
    use std::debug;

    // Function to demonstrate assertion short-circuit behavior
    public fun test_assert_short_circuit() {
        let called = false;

        // Define a function that sets called to true when invoked
        // Move closures or inline functions are not directly supported in Move,
        // so simulate side effect with a separate function call
        fun side_effect(): bool {
            called = true;
            false
        }

        // The argument to the assertion's second parameter should not be evaluated if condition is true
        debug::print(b"Before assert");
        // Instead of passing a function, pass an expression; move Move does not support function references directly
        // So, simulate the lazy evaluation by inlining the side_effect call within an if
        if (true) {
            assert!(true, b"Either way, second argument isn't evaluated");
        } else {
            // This block won't execute
            assert!(true, side_effect()); // But we want to simulate that side_effect isn't called when condition is true
        }
        debug::print(b"After assert when true condition");

        // Now test with a false condition; second argument should be evaluated
        called = false;
        debug::print(b"Before assert with false");
        if (false) {
            // Will not execute
            assert!(true, b"");
        } else {
            // Evaluate side_effect explicitly
            assert!(false, {
                side_effect()
            }); // side_effect should be called here
        }
        debug::print(b"After assert when false condition");
        assert!(called, b"side_effect was not called");
    }

    // Demonstrate verbose debug info about expansion
    public fun verbose_debug_info() {
        // Output before expansion
        debug::print(b"Program before expansion");
        // An example expansion output (simulated)
        debug::print(b"Expanding module, functions and enums...");
        // Output after expansion
        debug::print(b"Program after expansion");
    }

    // Set function return type via colon and type annotation
    public fun set_return_type(): u32 {
        let x = 42u32;
        x // return last expression
    }

    // Additional test to verify invocation
    public fun run_all_tests() {
        test_assert_short_circuit();
        verbose_debug_info();
        assert!(set_return_type() == 42u32, b"Unexpected return value");
    }
}