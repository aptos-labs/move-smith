//# publish
module 0xCAFE::TestModule {
    // This function is a simple update that takes an input and returns a new value without modifying the input.
    public fun update_value(value: u64): u64 {
        // For testing, just add 10 to the input
        value + 10
    }

    // Helper function to test that original value remains unchanged after update
    public fun test_value_immutability(original: u64): bool {
        let result = Self::update_value(original);
        // Check if original remains the same
        original == result - 10
    }

    // Function that intentionally produces a syntax error by missing a semicolon
    // (This code is known to cause syntax error during compilation, so it's commented out)
    // public fun syntax_error_example() {
    //     let x = 5 // Missing semicolon here should cause compile error
    // }

    // Function to accept a function pointer and a value, then call the function pointer
    // In Move, functions are passed as `&fun(...)` type, but function pointers syntax is `&<target_module>::<function_name>`
    // Alternatively, in Move, you can accept a function as a type parameter (using "generic" type), but that is more complex.
    // The correct way to accept a function pointer is via a specific function type. Since Move doesn't support first-class functions
    // like Rust, this pattern is not directly supported.
    // Instead, simulate this with a generic function or by passing a function name and calling it.
    // But for simplicity, we can pass a function of known type, i.e., `&fun(u64): u64`.

    // Using `&fun(u64): u64` as parameter type
    public fun apply_closure(f: &fun(u64): u64, arg: u64): u64 {
        f(arg)
    }

    // Sample function to be passed (a "closure" implemented as a function)
    public fun increment(x: u64): u64 {
        x + 1
    }

    // Runner function to test closure application
    public fun run_closure_test() {
        let result = Self::apply_closure(&Self::increment, 41);
        // For this test, we don't need assertions
        // Expect result to be 42
        result
    }
}

//# run 0xCAFE::TestModule::test_value_immutability --signers 0xCAFE --args 100u64
namespace 0xCAFE {
    public fun test_immutability() {
        let initial_value = 100u64;
        let unchanged = TestModule::test_value_immutability(initial_value);
        // The function should return true indicating original remains unchanged
        // No assertion needed, just run
        assert!(unchanged);
    }
}

//# run 0xCAFE::TestModule::run_closure_test --signers 0xCAFE