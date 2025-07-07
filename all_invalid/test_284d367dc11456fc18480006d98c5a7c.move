//# publish
module 0xabcde::counter {
    /// Creates a counter function that captures an initial count
    fun create_counter(initial: u64): |u64|() has copy {
        |delta| {
            let count = initial;
            // Return a function that adds delta to the captured count
            move || {
                let new_count = count + delta;
                // Update count for subsequent calls
                move |increment| {
                    let updated = new_count + increment;
                    // Ideally, capture updated for the next call, but moves are simpler here
                    updated
                }
            }
        }
    }

    /// Creates a multiplier function that captures a scale factor
    fun create_scaler(factor: u64): |u64|() has copy {
        |x| {
            move |y| factor * x * y
        }
    }

    /// Test nested function values with capture and composition
    fun test_nested_capture_and_composition() {
        // Create a counter starting at 10
        let counter_fn = create_counter(10);
        let counter_once = counter_fn(5); // captures 10, adds delta 5 to produce a function
        let result1 = counter_once(3); // Expected: 10 + 5 + 3 = 18
        assert!(result1 == 18, 0);

        // Create a scaler capturing factor 3
        let scale_by_3 = create_scaler(3);
        let scale_fn = scale_by_3(4); // Creates a function that multiplies by 3 * 4 = 12
        let result2 = scale_fn(2); // 12 * 2 = 24
        assert!(result2 == 24, 1);

        // Compose nested captures: scaler and counter
        let base_factor = 2;
        let scaler = |x| |y| base_factor * x * y;
        let counter = |z| |w| z + w + base_factor; // simple capture
        let composed = |x| |y| scaler(x)(counter(x)(y));
        let result3 = composed(3)(4); // 2 * 3 * (3 + 4 + 2) = 2 * 3 * 9 = 54
        assert!(result3 == 54, 2);
    }

    /// Test that nested function captures with mutable state (simulated with value captures)
    fun test_mutable_capture_simulation() {
        // Create a counter with initial value
        let counter_value = 7;
        // Define a function that captures this value and adds a delta
        let adder = |delta| {
            move |x| {
                // simulate mutation by recalculating
                counter_value + delta + x
            }
        };
        let add5 = adder(5);
        let result = add5(3); // 7 + 5 + 3 = 15
        assert!(result == 15, 3);

        let add10 = adder(10);
        let result2 = add10(2); // 7 + 10 + 2 = 19
        assert!(result2 == 19, 4);
    }
}

//# run 0xabcde::counter::test_nested_capture_and_composition
