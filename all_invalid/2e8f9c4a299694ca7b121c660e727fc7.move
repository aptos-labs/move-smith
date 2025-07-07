//# publish
module 0xCAFE::LocalBindingsAndInvariants {
    use std::invariant;

    // Define a struct with key and store for demonstration
    struct Example has key, store {
        x: u64,
        y: bool,
    }

    // A function demonstrating local bindings with and without type annotations
    public fun test_locals(): u64 {
        let a = 42u64;
        let b: u64 = 58;
        let c = (a + b);
        let d: (u64) = (c);
        let (e, f): (u64, bool) = (d, true);
        e
    }

    // A function showing invariant declarations with update mode and additional properties
    public fun test_invariant(): bool {
        // Declare an invariant on this function's context (arbitrary for test)
        invariant!(a > 0);
        invariant!(update); // declare an invariant with update mode
        invariant!(b > 0, 42);
        // also test invariant with update mode and additional property
        invariant!(update, c == 5, 99);

        true
    }

    // Runner function to call the above functions without arguments
    public fun runner(): u64 {
        let val = test_locals();
        let _ = test_invariant();
        val
    }
}
//# run 0xCAFE::LocalBindingsAndInvariants::runner


//# run
script {
    // Demonstrate local bindings in script with explicit and implicit types,
    // tuple unpacking with parentheses and type annotations,
    // and a simple use of invariant macro inline (assuming available in script).
    use 0xCAFE::LocalBindingsAndInvariants;

    fun main() {
        let x = 10u8;
        let y: u8 = 20;
        let z = (x + y);
        let (a, b): (u8, u8) = (z, 42);
        let t: (u8) = (a);

        let result = LocalBindingsAndInvariants::test_locals();

        // We won't do actual invariant macro calls here for simplicity,
        // but simulate that we are using grouping of tuple types for a variable:
        let pair: (u64, bool) = (100, true);

        // Call runner to test the module fully
        let output = LocalBindingsAndInvariants::runner();

        // No assert needed, just a successful run exercises compiler and VM
    }
}

// Featurres:
// 6058c5aaed6af10688ff5f26806ce65f: Declare local binding variables with optional type annotations and initializers using 'let' statements.
// 767bf91aad6a5d5cb7e70c3a9fb2aec2: Define invariant conditions in Move code with optional 'update' mode and additional properties.
// ad39b028249e2fb4817dd5167b7c0199: Declare types using parentheses for grouping types or tuples.
