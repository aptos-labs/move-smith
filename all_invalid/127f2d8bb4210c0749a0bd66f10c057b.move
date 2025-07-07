
//# publish
module 0xCAFE::AssertTest {
    use std::vector;
    use std::debug;

    // Function to demonstrate assertion short-circuit behavior
    public fun test_assert_short_circuit() {
        let called = false;

        // Define a function that sets called to true when invoked
        fun side_effect(): bool {
            called = true;
            false
        }

        // The argument to the assertion's second parameter should not be evaluated if condition is true
        debug::print(b"Before assert");
        assert!(true, side_effect()); // side_effect should NOT be called here
        debug::print(b"After assert when true condition");

        // Now test with a false condition; second argument should be evaluated
        called = false;
        debug::print(b"Before assert with false");
        assert!(false, side_effect()); // side_effect should be called here
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


//# run 0xCAFE::AssertTest::run_all_tests --signers 0xBEEF

// Featurres:
// 31024de0f5bf3119c5b885e1a34b30f8: Test that the second argument to assert! is only evaluated when the assertion condition is false.
// 04d8f35cd859951dbf262532ad7e0c4e: Output verbose debug information about the program before and after expansion.
// 4583f06af25db807e45322b7f49143fc: Set the return type of a function using a colon and type annotation.
