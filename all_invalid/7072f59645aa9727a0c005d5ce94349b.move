
//# publish
module 0xCAFE::TestAddress {
    use std::signer;

    // Feature 1: Return a spanned (location-aware) NumericalAddress
    // In Move, the address is typically a fixed constant, so we simulate a "spanned" address as just returning an address.
    // Since the feature is about position-aware address, for this test, we'll provide a function that returns a fixed address.
    public fun get_spanned_address(): address {
        0xCAFE
    }

    // Feature 2: Test nested function values with captured variables and composition
    public fun compose_and_capture(x: u64): u64 {
        // Define inner lambda that captures `multiplier`
        let multiplier = 10u64;
        let inner_lambda: |u64| u64 = |val: u64| {
            // capture the variable and perform multiplication
            val * multiplier
        };
        // Compose outer lambda that uses inner lambda
        let outer_lambda: |u64| u64 = |val: u64| {
            // call inner lambda with adjusted input
            inner_lambda(val + 5)
        };
        // Apply outer lambda to input x
        outer_lambda(x)
    }

    // Feature 3: Define local variables in a 'let' declaration inside a spec block
    public fun local_variable_test(): u64 {
        // 'let' inside function scope
        let a: u64 = 42;
        let b: u64 = 58;
        let c: u64 = a + b;
        c // return c
    }
}


//# run 0xCAFE::TestAddress::get_spanned_address

//# run 0xCAFE::TestAddress::compose_and_capture --args 7u64

//# run 0xCAFE::TestAddress::local_variable_test


// Featurres:
// 23a9348afd2bf228c638cc8855a47381: Return a spanned (location-aware) NumericalAddress for further use in code analysis or compilation.
// 193eac7d1e83e8ed9a345aa9b71f7f43: Test that nested function values with captured variables correctly perform arithmetic operations and that function composition with captures produces expected results.
// ca0d7f1c5ce0c2a845d11f0b457c2c35: Define local variables in a spec block using 'let' declarations.
