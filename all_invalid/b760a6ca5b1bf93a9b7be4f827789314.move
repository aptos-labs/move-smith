// Test transactional test for Aptos Move compiler/vm features.

//# publish
module 0xCAFE::WildcardTest {
    // Feature 1: Use the wildcard character '*' in a pattern (e.g., match, destructure) and import
    use std::vector::{self, *}; // Import all public functions and types from std::vector

    // Use * as parameter in let
    public fun do_destructuring() {
        let v = vector::empty<u8>();
        let x = (1u8, 2u8, 3u8);
        let (_, *, z) = x; // * as the middle pattern in tuple destructuring
        // The above is valid: (_, *, z) is short for: "match the first value, ignore the second (with *), and bind z to the third".
        let _ = z;
    }

    // Feature 2: loop with immediate return.
    public fun loop_with_immediate_return(): u8 {
        let i = 0u8;
        loop {
            // test immediate return
            return i + 42u8;
        };
        0u8
    }

    // Feature 3: No need to write acquires for Coin at module or function scope if not acquires parameter or return value.
    // The compiler should infer them.
    struct Coin has store, key {}

    public fun runner() {
        Self::do_destructuring();
        let res = Self::loop_with_immediate_return();
        let _ = res;
    }
}
//# run 0xCAFE::WildcardTest::runner --signers 0xCAFE

//# publish
module 0xBEEF::UsageTest {
    // Use '*' as a wildcard import in use (Feature 1, repeated)
    use std::signer::{self, *};

    public fun runner(s: &signer) {
        let addr1 = address_of(s);
        let addr2 = signer::address_of(s); // Should resolve to the same function!
        let _ = (addr1, addr2);
        // Feature 2: loop with immediate return in a script context style
        let v = loop {
            return 99u64;
        };
        let _ = v;
    }
}
//# run 0xBEEF::UsageTest::runner --signers 0xBEEF

//# run
script {
    use std::signer::*;
    fun main(s: &signer) {
        let a = address_of(s);
        let _ = a;
        loop {
            return;
        };
    }
}