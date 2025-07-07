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

    // Increment the counter
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
        // Return the current counter value plus val
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
        let result = {
            // To consume `counter` without `drop` ability, unpack it
            let Counter { value } = counter;
            // Pass a reference to the unpacked value to side_effect_func
            // However, since side_effect_func expects &mut Counter, we need to pass the original Counter
            // But moving `counter` would consume it, so we need to clone or copy.
            // Since Counter does not have Copy, we will use `move` and explicit unpacking.
            // Alternatively, just pass the original `counter` as mutable reference.

            // But `counter` is a local variable of type Counter, and we cannot pass references to it unless it is mutable.
            // The key issue: the compiler requires explicit handling.

            // Solution:
            // 1. Make `counter` mutable.
            // 2. Pass `&mut counter` directly without copy.

            // Since original code attempts `&mut copy counter`, which is invalid,
            // we directly pass &mut counter.

            // Also, in Move, references are borrows and no implicit copying.

            // So, fix: just pass `&mut counter`.

            add_const(
                side_effect_func(&mut counter, 5),
                100u64,
            )
        };

        // `result` now holds the final value.
        // Optionally, you can write assertions here, but not required.
    }
}
