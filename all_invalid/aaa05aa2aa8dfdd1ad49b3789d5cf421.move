
//# publish
module 0xFEED::EvalOrderTest {
    use std::vector;

    // This module is designed to test explicit evaluation order of arguments,
    // especially when mutations or side effects are involved.

    // A helper struct to hold mutable state for side effects
    struct Counter has store {
        value: u64,
    }

    // Function to create a new Counter
    public fun new_counter(initial: u64): Counter {
        Counter { value: initial }
    }

    // Incremenet the counter
    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    // Returns current counter value
    public fun get_value(counter: &Counter): u64 {
        counter.value
    }

    // Returns the current value plus a constant
    public fun add_const(value: u64, c: u64): u64 {
        value + c
    }

    // A function to test argument evaluation order involving mutations
    public fun side_effect_func(counter: &mut Counter, val: u64): u64 {
        // Increment counter as a side effect
        increment(counter);
        // Return the current counter value
        get_value(counter) + val
    }

    // Main test function to evaluate evaluation order:
    // It passes multiple arguments, where some are function calls with side effects.
    public fun test_eval_order() {
        // Initialize counter
        let counter = new_counter(10);

        // Call add_const with arguments: the first argument is a side-effect function
        // which mutates counter; the second argument is a static value.
        // We want to verify that the side-effect occurs before the addition.
        let result = add_const(
            side_effect_func(&mut copy counter, 5),
            100u64,
        );

        // Expected evaluation order: side_effect_func mutates counter -> add_const uses the new value -> final result
        // The counter's value should be 11 after side_effect_func
        // Final result: 11 + 100 = 111
        // (We do not assert but just expose the result.)
        result;
    }
}


//# run 0xFEED::EvalOrderTest::test_eval_order


// Featurres:
// ee4b315e0be7c22a22da1dacbf18eb52: Test that arguments to a function are evaluated from left to right, including when mutations or side effects are involved.
// 08aa38b120e4d4d8871c242a85c0b751: Add documentation comments and custom attributes to Move modules and their members for improved code annotation and metadata.
// 100166400090ecf8b12e619c555f0f86: Use the 'Copy' ability when the token is 'Tok::Copy'.
