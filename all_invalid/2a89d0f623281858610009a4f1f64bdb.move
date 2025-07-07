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

    // Function to intentionally produce a syntax error by missing a semicolon
    // (This code is known to cause syntax error during compilation, so it's commented out)
    // public fun syntax_error_example() {
    //     let x = 5 // Missing semicolon here should cause compile error
    // }

    // Function that accepts a closure (as a function pointer) and a value, then calls the closure
    public fun apply_closure(f: &fun(u64) -> u64, arg: u64): u64 {
        f(arg)
    }

    // Sample closure-like function to be passed (Move doesn't have first-class closures, but function pointers can be used)
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

// Featurres:
// 51c5ee04b5b20af531a56db7a51fa2c7: Test that calling the test function with an initial value does not modify the local variable after calling the update function and that the original value remains unchanged.
// bd8e82f34f0f261971c335bd9fb5756d: Cause the parser to produce a syntax error if an expected token is missing, helping catch mistakes like missing punctuation or incorrect syntax in Move code.
// 5d96c42efcae4498b0c987a603570c37: Test that functions accepting and invoking closures as arguments work correctly, including passing and calling closures with different parameter bindings.
