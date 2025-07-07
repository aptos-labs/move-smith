// Test of Move compiler + VM for requested features

// ----------------------------
// 1. Loop with immediate break
// ----------------------------

//# publish
module 0xCAFE::LoopBreakTest {
    public fun run() {
        let mut i = 0u8;
        // This loop should execute once and break immediately
        loop {
            i = 1u8;
            break;
        };
        // After the loop, i == 1u8
        // No assertion required; just that it executes without error
    }
}
//# run 0xCAFE::LoopBreakTest::run --signers 0xCAFE

// ---------------------------------
// 2. Check for a token in a vector
// ---------------------------------

//# publish
module 0xCAFE::TokenCheck {
    use std::vector;

    /// Returns true if `token` is found in `tokens`
    public fun token_exists(tokens: vector<u8>, token: u8): bool {
        let len = vector::length(&tokens);
        let mut i = 0;
        while (i < len) {
            if (vector::borrow(&tokens, i) == &token) {
                return true;
            };
            i = i + 1;
        };
        false
    }

    /// Runner for test: checks if '42u8' is in [10, 20, 42, 50]
    public fun runner() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);
        vector::push_back(&mut v, 42);
        vector::push_back(&mut v, 50);
        let found = Self::token_exists(v, 42);
        // Ignore the result; just check that code runs
        found;
    }
}
//# run 0xCAFE::TokenCheck::runner --signers 0xCAFE

// --------------------------------------------------------
// 3. Conditional unpacking, returning Option::none on fail
// --------------------------------------------------------

//# publish
module 0xCAFE::ConditionalUnpack {
    use std::option::{Self, Option};

    struct Pair has copy, drop { a: u64, b: u64 }

    /// Try to unpack the two fields from the given Pair struct,
    /// returning `none` if any field is missing (simulate, always present)
    public fun unpack_fields(pair: Pair): Option<(u64, u64)> {
        // In Move, struct fields cannot be "missing", so simulate a failure
        if (pair.a == 0 || pair.b == 0) {
            // Simulate "assignment failed": return none
            option::none()
        } else {
            option::some((pair.a, pair.b))
        }
    }

    /// Runner to exercise both paths
    public fun runner() {
        let p1 = Pair { a: 1, b: 2 };
        let p2 = Pair { a: 0, b: 2 };
        let p3 = Pair { a: 1, b: 0 };

        let _r1 = Self::unpack_fields(p1); // should return Some
        let _r2 = Self::unpack_fields(p2); // should return None
        let _r3 = Self::unpack_fields(p3); // should return None
        // Just run for side-effects
    }
}
//# run 0xCAFE::ConditionalUnpack::runner --signers 0xCAFE
