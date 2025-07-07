// Import necessary modules
address 0x1 {
//# publish
    module my_module {
        // Features:
        // - Entry points implemented in scripts
        // - Local variable assignments inside and outside loops tested
        // - 'internal' visibility used
        // - Generics and type parameters handled
        // - Return statements in expressions
        // - Closures stored respecting their ability and attribute

        // Example struct with a type parameter
        struct MyStruct<T> {
            value: T,
        }

        // Internal function restricted within the module
        internal fun increment<T: copy + add<item = u64>>(val: T): T {
            // For simplicity, assume T can support addition with u64
            // and returns the incremented value
            // Note: Actual implementation might vary
            // Using return statement as specified
            return val + 1 as T;
        }

        // Script (entry point) to perform a test
//# run
        script {
            fun test_loop_behavior() {
                let x: u64 = 0;

                let limit = 5;

                // Outer variable assignment
                let shadow_x = x;

                // While loop
                while shadow_x < limit {
                    // Inside loop, modify shadow variable
                    shadow_x = shadow_x + 1;

                    // Shadowing outer variable
                    let x = shadow_x;

                    // Using a closure - stored only if it has 'store' ability
                    let closure = || {
                        // Access outer variable x
                        x + 2
                    };

                    let result = closure();

                    // Optional: do something with result
                }

                // After loop, ensure variables hold expected values
                assert (shadow_x == limit);
            }

            // Call the test function
            test_loop_behavior();
        }
    }
}
