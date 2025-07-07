// Transactional test for:
// 1. Specs and variable bindings with Spec expressions
// 2. Deprecated modules usage
// 3. Wildcard `*` in specs

//------------------- MODULE 0 -------------------------
//# publish
module 0xCAFE::SpecTest {
    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    /// runner to test specs
    public fun test_spec(): u8 {
        Self::add(1, 2)
    }

    spec add {
        let sum: u8 = result;
        ensures sum == x + y;
        ensures result == x + y;
        // wildcard usage in spec, e.g. for any input
        // this postcondition says: for any inputs, result >= 0
        ensures result >= *;
    }
}

//# run 0xCAFE::SpecTest::test_spec --signers 0xCAFE

//-------------------------------------------------------

//------------------- MODULE 1 (DEPRECATED) -------------
//# publish
#[deprecated = "Use NewMath instead"]
module 0xDEAD::OldMath {
    public fun multiply(x: u8, y: u8): u8 { x * y }

    public fun deprecated_add(x: u8, y: u8): u8 { x + y }
}

//# publish
module 0xBEEF::UseDeprecated {
    use 0xDEAD::OldMath;

    public fun call_deprecated(): u8 {
        OldMath::deprecated_add(10, 20)
    }

    /// will call deprecated function; should show warning
    public fun runner(): u8 {
        Self::call_deprecated()
    }
}

//# run 0xBEEF::UseDeprecated::runner --signers 0xBEEF

//-------------------------------------------------------

//------------------- MODULE 2 -------------------------
//# publish
module 0xF00D::StarSpec {
    struct T has copy, drop { value: u64 }

    public fun mk_star(val: u64): T {
        T { value: val }
    }

    public fun runner(): T {
        Self::mk_star(42)
    }

    spec mk_star {
        // Use wildcard in ensures; result can be any value of T
        ensures result == *;
    }
}

//# run 0xF00D::StarSpec::runner --signers 0xF00D