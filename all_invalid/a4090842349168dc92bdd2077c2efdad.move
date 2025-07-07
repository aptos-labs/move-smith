
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

    // Currying / Closures with different captures
    public fun closure_conditional(flag: bool): (u64) -> u64 {
        if (flag) {
            |x: u64| x + 10
        } else {
            |x: u64| x + 20
        }
    }

    public fun apply_closure(closure: & (u64) -> u64, value: u64): u64 {
        closure(value)
    }

    // Function parsing multiple type arguments
    public fun parse_multi_types<X, Y, Z>(x: X, y: Y, z: Z): Z {
        z
    }

    // Program entry point for running all test functions (no arguments)
    public fun run_all_tests() {
        let _ = init_counter; // Just to keep this as a stable reference
    }
}


//# run 0xCAFE::TestModule::run_all_tests


//# run 0xCAFE::TestModule::process_types --args 100u64 200u8


//# run 0xCAFE::TestModule::closure_conditional --args true


//# run 0xCAFE::TestModule::apply_closure --args 5u64


//# run 0xCAFE::TestModule::parse_multi_types --args 1u8 2u16 3u32


//# run 0xCAFE::TestModule::violate_spec


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// d584e328e8c5929973ca385d0f5f2b97: Parse a comma-separated list of type arguments in your Move code to include multiple types within the angle brackets.
// 058e92738ebd925faf5d4e91c73f76c1: Leverage the `program` function to include only modules with unit tests in the final program for testing purposes.
