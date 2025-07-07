//# publish
module 0xA::CondMutRefTest {
    use std::signer;
    use std::vector;

    /// 1. Mutable references to conditionals and nested blocks

    fun inc_if_true(val: &mut u64, cond: bool) acquires Account {
        // conditionally mutate val via reference
        if (cond) {
            *val = *val + 10;
        } else {
            // nested block mutates val via reference too
            {
                *val = *val + 1;
            }
        }
    }

    public fun runner() {
        let mut x = 100u64;
        let y = &mut x;
        let cond = true;
        Self::inc_if_true(y, cond);
        // another branch
        let cond2 = false;
        Self::inc_if_true(y, cond2);
        // After both: x should be 100+10+1 = 111
        // (no assertion required, but result is observable by reading `x` or printing/logging)
        // Let's also test more deeply nested references.
        {
            let z = &mut x;
            let cond3 = true;
            if (cond3) {
                *z = *z + 100;
            }
        }
        // after this: x = 211
        // No output or assertion required.
    }
}
//# run 0xA::CondMutRefTest::runner --signers 0xA

//# publish
module 0xA::UseAliasTest {
    use std::vector;
    use 0xA::CondMutRefTest as CMR;
    // The presence of the `as CMR` alias
    // Should not interfere with the ability to use either name elsewhere in the file

    public fun alias_demo() {
        let mut v = vector::empty<u8>();
        vector::push_back<u8>(&mut v, 99u8);
        // Use via the alias
        let mut y = 50u64;
        let p = &mut y;
        // invoke something from CMR, via alias
        CMR::inc_if_true(p, true);
        // Also, can still use original names (like vector) without conflict
        let w = vector::length<u8>(&v);
        // No assertions are done.
    }

    public fun runner() {
        Self::alias_demo();
    }
}
//# run 0xA::UseAliasTest::runner --signers 0xA

//# publish
module 0xA::NestedInlineFunctionTest {
    // inline function, nested call
    fun inner(x: u64): u64 {
        x * 2
    }

    fun middle(y: u64): u64 {
        Self::inner(y) + 3
    }

    public fun outer(z: u64): u64 {
        // Calls the two nested functions
        Self::middle(z) * 5
    }

    public fun runner() {
        let _result = Self::outer(4); // (4*2)+3 = 11, 11*5 = 55
        // No assertion or output.
        // Just ensuring nested inline functions execute
    }
}
//# run 0xA::NestedInlineFunctionTest::runner --signers 0xA