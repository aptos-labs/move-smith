//# publish
module 0xCAFE::RestrictOps {
    /// This module tests restricting internal operations and verifies
    /// spec conditions on functions and module.

    use std::signer;
    use std::vector;

    /// A struct only constructible inside this module.
    struct Secret has copy, drop, store {
        value: u64,
    }

    /// Internal function only callable within this module.
    /// It creates a Secret struct.
    fun make_secret_internal(v: u64): Secret {
        Secret { value: v }
    }

    /// Public function callable from outside, but it cannot create Secret.
    public fun create_public_value(v: u64): u64 {
        // returns value directly, does not leak Secret struct.
        v * 10
    }

    /// Function callable internally that returns Secret.
    fun get_secret(): Secret {
        make_secret_internal(42)
    }

    /// Runner function that calls internal function, no arguments.
    public fun runner() {
        let _secret = get_secret();
        // no return needed
    }

    /// Function with a spec block on it for verification
    /// Spec declares postcondition that output equals input * 10.
    public fun verified_function(x: u64): u64 {
        // spec: ensures result == x * 10;
        x * 10
    }

    /// Function with spec on module level for demonstration.
    /// No function call needed here; spec check only.
    spec module {
        // Module invariant example, always true for this example.
        invariant true;
    }
}
//# run 0xCAFE::RestrictOps::runner --signers 0xCAFE
//# run 0xCAFE::RestrictOps::verified_function --args 7u64

//# run
script 0xCAFE::RunScripts {
    use 0xCAFE::RestrictOps;

    fun main() {
        // Run public function
        let x = RestrictOps::create_public_value(5);
        // Run verified function directly
        let y = RestrictOps::verified_function(3);

        // Just demonstrating read, no asserts required.
        let _ = x + y;
    }
}

// Featurres:
// bf54b9235fae757d7e57dbcdc5b32977: Restrict specific operations so they can only be performed within the module that defines them.
// 3b40bd96aea75ce70537ab293569a98b: Define functions that should be verified for compliance with module documentation and compiler rules.
// ad61769847cc49bf32acec870432b4d9: Apply spec blocks or conditions to specific named entities such as functions or modules in your code.
