
//# publish
module 0xCAFE::AbilitySpecTest {
    use std::vector;
    use std::signer;

    // 1. Use 'has' keyword to specify ability constraints for a type parameter in function signature
    public fun generic_copy_func<T: copy>(value: T): T {
        // simply copy and return the value
        copy value
    }

    // Struct with different abilities
    struct CopyStore has copy, store {
        x: u8
    }

    struct StoreNoCopy has store {
        y: u64
    }

    struct KeyCopy has key, copy {
        id: u64
    }

    // 2. Write a pattern with .. in pattern matching
    enum E has copy, drop {
        A,
        B(u8, u8, u8),
        C {a: u8, b: u8, c: u8, d: u8},
    }

    public fun pattern_match_rest(e: E): u8 {
        match e {
            E::A => 0,
            E::B(_, b, ..) => b,
            E::C { a, .. } => a,
            // the .. means rest of the fields wildcard
        }
    }

    // 3. Writing specification conditions for module and functions
    spec module {
        // invariant always holds that 1 + 1 == 2
        invariant true;
    }

    // Spec for the function that depends on input to output
    public fun spec_checked_sum(x: u8, y: u8): u8 {
        // Add with safety for overflow not needed, u8 wrapping is ok for the test.
        let sum = x + y;
        sum
    }
    spec spec_checked_sum {
        requires true;
        ensures result == x + y;
    }

    // Spec to ensure input vector length keeps unchanged after a function that returns the same vector
    public fun identity_vec(v: vector<u8>): vector<u8> {
        v
    }
    spec identity_vec {
        ensures vector::length(result) == vector::length(v);
    }

    // Runner function with signature ability constraint to test generic_copy_func
    public fun runner_copy() {
        let a = CopyStore { x: 5 };
        let _copied = generic_copy_func<CopyStore>(a);
    }

    // Runner for pattern matching with .. usage
    public fun runner_pattern() {
        let e1 = E::B(1, 2, 3);
        let v1 = pattern_match_rest(e1);
        let e2 = E::C { a: 9, b: 8, c: 7, d: 6 };
        let v2 = pattern_match_rest(e2);
    }

    // Runner for spec testing functions
    public fun runner_spec() {
        let _ = spec_checked_sum(3, 4);
        let v = vector::empty<u8>();
        let _ = identity_vec(v);
    }
}



//# run 0xCAFE::AbilitySpecTest::runner_copy



//# run 0xCAFE::AbilitySpecTest::runner_pattern



//# run 0xCAFE::AbilitySpecTest::runner_spec
