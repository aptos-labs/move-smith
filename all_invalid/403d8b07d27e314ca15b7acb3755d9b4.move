//# publish
module 0xCAFE::TestModule {

    // Internal resource for testing internal visibility
    struct Counter {
        count: u64,
    }

    // Public function to initialize the resource
    public fun init_counter(s: &signer) {
        move_to<Counter>(s, Counter { count: 0 });
    }

    // Internal function: only accessible within this module
    fun increment_counter_internal(counter_ref: &mut Counter) {
        counter_ref.count += 1;
    }

    // Public function that calls internal function
    public fun increment_counter(s: &signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(s));
        increment_counter_internal(counter_ref);
    }

    // Test: external modules should not access internal functions
    // (Will be tested via script invocation making sure no external access allowed)

    // Function with multiple type parameters
    public fun process_types<A, B>(a: A, b: B): (A, B) {
        (a, b)
    }

    // Function that intentionally violates spec to test error handling
    public fun violate_spec() {
        // Pure functions cannot call impure functions, but here mock an impure scenario
        // Suppose we violate by calling an external API (simulate with invalid code)
        // For test purpose, just panic
        panic(b"Intentional violation");
    }

    // Corrected: function with conditional closures
    // Previously invalid syntax caused the compile error
    // Instead, define functions returning closures with explicit return types
    public fun closure_conditional(flag: bool): (u64) -> u64 {
        if (flag) {
            // Return a closure that adds 10
            |x: u64| { x + 10 }
        } else {
            // Return a closure that adds 20
            |x: u64| { x + 20 }
        }
    }

    // Function to apply a closure
    public fun apply_closure(closure: & (u64) -> u64, value: u64): u64 {
        closure(value)
    }

    // Function parsing multiple type arguments
    public fun parse_multi_types<X, Y, Z>(x: X, y: Y, z: Z): Z {
        z
    }

    // Program entry point for running all test functions (no arguments)
    public fun run_all_tests() {
        // For demonstration, call some functions
        // e.g., process_types, closure_conditional, etc.
        let _ = process_types<u64, u8>(42, 255);
        let closure_true = closure_conditional(true);
        let result_true = apply_closure(&closure_true, 5);
        // Using the result to ensure the functions work
        // Similarly, do other test calls if needed
    }
}
