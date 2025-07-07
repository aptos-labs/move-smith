//# publish
module 0xCAFE::TestFailures {
    use std::error;
    use std::signer;

    /// A struct with an unused type parameter <T> marked as phantom
    struct Phantom<T> has copy, drop, store {
        phantom: phantom PhantomType<T>,
    }

    /// PhantomType is a dummy wrapper to mark phantom type arguments (no fields).
    struct PhantomType<T> has drop {}

    /// A simple function that will panic (abort) at runtime with an abort code.
    #[expected_failure]
    public fun will_abort(): u64 {
        abort 42;
    }

    /// A function that aborts with a specific code and is expected to fail with code 42.
    #[expected_failure(42)]
    public fun abort_42(): u64 {
        abort 42;
    }

    /// A function that intentionally does NOT abort but is incorrectly marked expected failure.
    /// This tests that the runner observes expected failures.
    #[expected_failure]
    public fun no_abort(): u64 {
        0
    }

    /// A runner function that calls all above functions to exercise their behavior
    public fun run(): u64 {
        // The calls must be done in separate transactions or as separate run lines below.
        0
    }
}
//# run 0xCAFE::TestFailures::run --signers 0xCAFE

//# publish
module 0xCAFE::SpecLoopInvariant {
    use std::vector;

    /// A function with a loop that uses spec with invariant conditions that are only 'invariant'.
    public fun sum_to_n(n: u64): u64 {
        let mut acc = 0u64;
        let mut i = 0u64;
        while (i < n) {
            spec {
                invariant i <= n;
                invariant acc <= n * n;
            }
            acc = acc + i;
            i = i + 1;
        }
        acc
    }

    /// Runner function for verification if applicable
    public fun run(): u64 {
        sum_to_n(10)
    }
}
//# run 0xCAFE::SpecLoopInvariant::run --signers 0xCAFE

//# run 0xCAFE::TestFailures::will_abort --signers 0xCAFE
//# run 0xCAFE::TestFailures::abort_42 --signers 0xCAFE
//# run 0xCAFE::TestFailures::no_abort --signers 0xCAFE

// Featurres:
// b6bf5ea92384cae62bdb1b60ae305195: Annotate Move functions or tests with #[expected_failure] or #[expected_failure(KIND)] attributes to specify expected runtime failures.
// 5431d9d787802c0b3a33d0e545d3710f: Utilize unused type parameters in Move structs without warnings by marking them as phantom when they are not used in fields.
// c9132e0a56364340f2fde78e0448979f: Ensure only 'invariant' conditions are present in a spec block used as a loop invariant
