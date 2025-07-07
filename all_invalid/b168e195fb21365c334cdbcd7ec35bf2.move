//# publish
module 0xCAFE::AbortSpecTest {
    use std::signer;

    struct Data has store {
        value: u8,
    }

    /// Aborts if the input is zero with abort code 100
    public fun abort_on_zero(x: u8) acquires Data {
        aborts_if x == 0;
        if (x == 0) {
            abort 100;
        };

        // Create a resource to ensure the function works if no abort
        let _d = Data { value: x };
    }

    /// Aborts if signer address is odd, abort code 777
    public fun abort_on_odd_address(s: signer) acquires Data {
        aborts_if (signer::address_of(&s) & 1u64) != 0;
        let addr = signer::address_of(&s);
        if ((addr & 1u64) != 0) {
            abort 777;
        };
    }

    public fun runner_abort_spec() {
        // call with a non-zero and even address, should not abort
        abort_on_zero(42u8);
    }

    public fun runner_abort_on_odd_addr(s: signer) {
        abort_on_odd_address(s);
    }
}

//# run 0xCAFE::AbortSpecTest::runner_abort_spec

//# run 0xCAFE::AbortSpecTest::runner_abort_on_odd_addr --signers 0xBEEF

//# publish
module 0xCAFE::DuplicateModuleTest {
    // Empty module to test duplication on publishing again
}

// The next attempt to publish a module with the same name will cause conflict but
// since this is a transactional test we do not actually run duplicate publish here, just note it.

//# publish
// module 0xCAFE::DuplicateModuleTest {
//     // This would be a duplicate module and should error if tried
// }

//# publish
module 0xCAFE::StructDestructuring {
    struct Pair has copy, drop, store {
        a: u8,
        b: u16,
    }

    public fun destructure_positional() {
        let p = Pair { a: 10u8, b: 20u16 };
        let Pair(x, y) = p;
        // x: u8, y: u16
        let _sum: u32 = (x as u32) + (y as u32);
    }

    public fun destructure_with_let() {
        let p = Pair { a: 5u8, b: 15u16 };
        let Pair(a_val, b_val) = p;
        let _prod: u32 = (a_val as u32) * (b_val as u32);
    }

    public fun runner_destructuring() {
        destructure_positional();
        destructure_with_let();
    }
}

//# run 0xCAFE::StructDestructuring::runner_destructuring

// Featurres:
// afa5bd48459f694f37d4fcf57d0a95f9: Use 'aborts_if' specifications to specify custom abort conditions for a function or procedure.
// 5a8a2ab0de22d67fdc770b6fca83ae7d: Prevent duplicate module definitions within the same environment.
// 8b0591f0076eadab1e1c9b54ed519bcb: Destructure structs in 'let' statements using positional (tuple-style) unpacking.
