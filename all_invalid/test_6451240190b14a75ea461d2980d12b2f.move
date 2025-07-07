//# publish
module 0xabcde::nested_functions {
    // Import necessary standard library modules for serialization and strings
    use std::bitwise;
    use std::string::{Self};
    use std::vector;

    // Define a type for function references with capture
    struct CaptureFn(<u8> has copy, drop);
    // A simple function returning a numerical value
    fun get_base_value(): u8 {
        7
    }

    // Entry function to test nested and higher-order functions
    public fun run_tests() {
        // Basic nested closure capturing a local variable
        let outer_capture = || {
            let base = get_base_value();
            // Inner closure capturing outer variable
            || {
                let captured = base;
                captured
            }
        };

        // Assert that the inner closure returns the expected value
        assert!(outer_capture()() == 7);

        // Creating a closure that captures a value, then further nests closures with modifications
        let multiplier = 3u8;

        let nested_closure = || {
            let local = multiplier;
            // Closure capturing local value
            || {
                local * 2
            }
        };

        // Validate the nested closure computes correctly
        assert!(nested_closure()() == 6);

        // Compose multiple nested closures with different captures
        let deep_closure = || {
            let base = get_base_value();
            let compute = || {
                let intermediate = base + 10;
                || {
                    intermediate * 2
                }
            };
            compute()
        };
        // The expected value: (7 + 10) * 2 = 34
        assert!(deep_closure()() == 34);

        // Create a recursive higher-order closure (simulated via nested definitions)
        let rec_closure = || {
            let rec_func = || {
                // Base case condition
                if false {
                    0
                } else {
                    // Simulate recursion by calling recursively a different closure
                    1 + rec_func()
                }
            };
            rec_func()
        };

        // Since recursion is not real, this will cause infinite loop if executed.
        // But for safety, we simulate a terminated recursive call by defining a base case
        // in the actual test, let's verify a simple closure with captured value
        let capture_value = true;
        let higher_order_fn = || {
            if capture_value {
                || 100
            } else {
                || 0
            }
        };

        // Invoke the closure returned by the higher-order function
        let result_closure = higher_order_fn();
        assert!(result_closure() == 100);

        // Create a higher-order closure that captures and modifies a captured variable
        let mut counter = 10u64;
        let holder_fn = || {
            let cap = counter;
            // Closure capturing the current value of counter
            || {
                counter += 1;
                cap
            }
        };

        let f1 = holder_fn();
        let f2 = holder_fn();

        // The first call should return the original value
        assert!(f1() == 10);
        // The second call should also return 10, counter incremented afterwards
        assert!(f2() == 10);
        // Now, the global counter should be incremented
        assert!(counter == 12);
    }
}

//# run 0xabcde::nested_functions::run_tests --args