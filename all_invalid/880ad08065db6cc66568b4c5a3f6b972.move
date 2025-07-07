// Test for: 
// 1. Retrieve the 'BUILTIN_TYPE_NAMES' set as a static reference,
// 2. Test the apply function for anonymous function execution,
// 3. Test lambda promotion to top-level private functions by defining lambdas inside functions.

// ADDRESS: 0xCAFE

//# publish
module 0xCAFE::BuiltinTypeNames {
    use std::vector;

    // A vector of bytes representing built-in type names as byte strings.
    // Simulating the BUILTIN_TYPE_NAMES set; in real Move stdlib it's a static vector.
    const BUILTIN_TYPE_NAMES: vector<vector<u8>> = vector[
        b"bool",
        b"u8",
        b"u64",
        b"u128",
        b"address",
        b"signer",
        b"vector",
        b"struct",
        b"option"
    ];

    /// Public function to get the built-in type names vector by shared reference.
    public fun get_builtin_type_names(): &vector<vector<u8>> {
        &Self::BUILTIN_TYPE_NAMES
    }

    /// Apply function: takes two u64 and a function that takes two u64 and returns u64,
    /// applies the function to the inputs, returns the result.
    public fun apply(x: u64, y: u64, f: &fun(u64, u64): u64): u64 {
        f(x, y)
    }

    // Private lambda function that adds two u64 numbers
    // This tests that lambda expressions inside functions are promoted to module scope.
    // It is private and used only inside the module.
    fun private_add_lambda(a: u64, b: u64): u64 {
        a + b
    }

    // Runner function to test:
    // - retrieving BUILTIN_TYPE_NAMES reference,
    // - using apply with the private lambda add function.
    public fun runner() {
        // Retrieve reference to BUILTIN_TYPE_NAMES vector.
        let names_ref = Self::get_builtin_type_names();

        // Use apply to add two numbers via private_add_lambda.
        let result = Self::apply(10u64, 20u64, &Self::private_add_lambda);

        // Use result and names_ref to prevent compiler warnings about unused vars.
        let _ = (names_ref, result);
    }
}
//# run 0xCAFE::BuiltinTypeNames::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::BuiltinTypeNames;

    fun main() {
        // Call runner function inside module to test all features.
        BuiltinTypeNames::runner();
    }
}

// Featurres:
// 8a179fa2700dc8ec1d5a56648cc1defd: Retrieve the 'BUILTIN_TYPE_NAMES' set as a static reference, enabling efficient lookups of built-in type names within Move code.
// dd5fd14ccc0eef054bd1323604bce732: Test that the apply function correctly executes a provided anonymous function to add two u64 values.
// 68077687b42f75f155e9d5eb21717b87: Have the compiler automatically promote lambda expressions enclosed in functions or specs to top-level (module scope) private functions, so that lambdas behave as first-class closures.
