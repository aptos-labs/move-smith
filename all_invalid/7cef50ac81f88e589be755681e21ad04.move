// #publish
module 0xCAFE::InvariantTest {
    use std::signer;

    /// A singleton struct with positional fields
    struct Singleton(u64);

    /// A singleton struct with named fields
    struct NamedSingleton {
        id: u64,
    }

    /// Struct to hold a value with an invariant that depends on a condition expression
    struct CondInvariant {
        val: u64,
    }

    // Invariant: if val > 10, then val < 100
    spec CondInvariant {
        invariant cond_invariant {
            let r = self.val;
            (r > 10) ==> (r < 100)
        }
    }

    /// A function that returns a Singleton struct exposing positional fields usage
    public fun create_singleton(value: u64): Singleton {
        Singleton(value)
    }

    /// A function that returns NamedSingleton struct
    public fun create_named_singleton(value: u64): NamedSingleton {
        NamedSingleton { id: value }
    }

    /// A function to demonstrate usage of binding variable r in an invariant (already done in spec)
    public fun new_cond_inv(val: u64): CondInvariant {
        CondInvariant { val }
    }

    /// A runner function without arguments which will be called by the runner command
    public fun runner() {
        let s = create_singleton(42);
        let ns = create_named_singleton(7);
        let ci = new_cond_inv(20);
        let ci2 = new_cond_inv(5); // val <= 10, so invariant condition does not apply

        // dummy uses to prevent "unused variable" warnings
        let _ = s;
        let _ = ns;
        let _ = ci;
        let _ = ci2;
    }
}
// #run 0xCAFE::InvariantTest::runner --signers 0xCAFE

// #publish
module 0xCAFE::RangeBindingTest {
    /// A struct with a variable in a range expression used in specification
    struct Ranged {
        x: u8,
    }

    spec Ranged {
        invariant range_invariant {
            // bind r to the field in the invariant:
            let r = self.x;
            r >= 1 && r <= 10
        }
    }

    /// Create a struct instance that satisfies the range bound
    public fun create_valid(): Ranged {
        Ranged { x: 5 }
    }

    /// Create a struct instance that fails the invariant (for the sake of completeness)
    public fun create_invalid(): Ranged {
        Ranged { x: 20 }
    }

    /// Runner function to call create_valid and create_invalid without args
    public fun runner() {
        let a = create_valid();
        let b = create_invalid();

        // dummy use
        let _ = a;
        let _ = b;
    }
}
// #run 0xCAFE::RangeBindingTest::runner --signers 0xCAFE

// #run 0xCAFE::InvariantTest::create_singleton --args 88u64 --signers 0xCAFE
// #run 0xCAFE::InvariantTest::create_named_singleton --args 99u64 --signers 0xCAFE
// #run 0xCAFE::InvariantTest::new_cond_inv --args 15u64 --signers 0xCAFE

// #run 0xCAFE::RangeBindingTest::create_valid --signers 0xCAFE
// #run 0xCAFE::RangeBindingTest::create_invalid --signers 0xCAFE

// #run 0xCAFE::InvariantTest::runner --signers 0xCAFE
// #run 0xCAFE::RangeBindingTest::runner --signers 0xCAFE

// Featurres:
// 7162635b65d891d4b5881a0396dd4f7a: Reference the condition expressions associated with invariants in specifications.
// 562d1893fa863035ca81251d4b4ccf8f: Define structs with a single set of fields (singleton structs), optionally positional.
// 6f53858d98e5fdab1fdd66c0cd78c269: Bind each range 'r' associated with variables to the unbound context, enabling correct scoping and usage.
