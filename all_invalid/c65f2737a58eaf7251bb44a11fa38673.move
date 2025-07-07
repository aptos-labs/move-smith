
//# publish
module 0xCAFE::TestAddress {
    // Removed unused alias 'signer' to clean up warnings
    // use std::signer;  // This line is unnecessary if 'signer' is unused

    // Feature 1: Return a spanned (location-aware) NumericalAddress
    // In Move, the address type is fixed as 'address' and cannot be directly returned as a literal.
    // To return an address, use the 'address' literal syntax.
    public fun get_spanned_address(): address {
        0xCAFE  // Literal of type address
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

    // Feature 3: Define local variables in a 'let' declaration inside a function
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
