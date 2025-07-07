
//# publish
module 0xCAFE::AccessControlTest {
    // Internal private function
    fun private_function() {
        // does nothing
    }

    // Public function that calls private function internally
    public fun call_private() {
        private_function();
    }

    // Public function that returns unit type '()'
    public fun get_unit_type(): () {
        ()
    }

    // Private function with unit return
    fun private_unit_func(): () {
        ()
    }

    // Public function that calls private unit function
    public fun call_private_unit(): () {
        private_unit_func()
    }
}


//# run 0xCAFE::AccessControlTest::call_private
// Expect failure: should not compile or should error on private function call outside module


//# run 0xCAFE::AccessControlTest::get_unit_type
// Expects to run successfully, returning '()'


//# run 0xCAFE::AccessControlTest::call_private_unit
// Expects to run successfully, calling a private function indirectly


//# publish
module 0xCAFE::LoopWithSpec {
    use std::spec;

    // Function to test loop with spec block
    public fun loop_with_spec(limit: u64): u64 {
        let counter = 0;
        let sum = 0u64;

        // Loop with spec block checking invariants during iterations
        while (counter < limit) {
            spec {
                // Invariant: counter is always less than or equal to limit during loop
                assert!(counter <= limit);
            };
            // Update counter and sum
            counter = counter + 1;
        };
        // sum is just the number of iterations
        counter
    }

    // Function exercising a loop with spec block involving a private function
    private fun private_increment(x: u64): u64 {
        x + 1
    }

    public fun loop_with_private_call(limit: u64): u64 {
        let counter = 0;
        while (counter < limit) {
            spec {
                // invariant: counter is less than limit
                assert!(counter < limit);
            };
            // Call private function indirectly
            let new_counter = private_increment(counter);
            counter = new_counter;
        };
        counter
    }
}

//# run 0xCAFE::LoopWithSpec::loop_with_spec --args 10u64
// Expects to run successfully, returns 10


//# run 0xCAFE::LoopWithSpec::loop_with_private_call --args 5u64
// Expects to run successfully, returns 6


// Featurres:
// 26c1572d48880ce3286448ae409db5c6: Restrict calls to private functions so they cannot be accessed from outside their defining module
// 1d057386bcda39af1f6c64e60c26b1f8: Define unit types using empty parentheses '()'.
// 99a848baa3c1e5d70060e3784b66eb90: Use `spec` blocks to specify properties that must hold during loop execution.
