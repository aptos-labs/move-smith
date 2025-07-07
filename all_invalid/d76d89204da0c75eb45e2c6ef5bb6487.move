
//# publish
module 0xCAFE::AdvancedSpecTest {
    use std::vector;

    // A dummy struct for spec usage
    struct R has key {
        val: u64,
    }

    /// A public function with a spec block containing a universal quantifier with a where clause
    /// and inferred integer literals.
    public fun spec_fun(a: u64, b: u64): u64 {
        let res = a + b;
        res
    }
    spec fun spec_fun(a: u64, b: u64) {
        // Spec: For all x in 0..10 where x is even, assert that x*2 < 25
        // Which means only even x's in range 0..10 are considered
        forall x: u64 where 0 <= x && x < 10 && x % 2 == 0: {
            assert!(x * 2 < 25, 777);
        };

        // Spec: a and b are less than 2^32, use inferred literal without suffix (largest applicable is u64)
        assert!(a < 4294967296, 1001);
        assert!(b < 4294967296, 1002);

        // Spec: The function result equals a + b
        assert!(spec_fun(a, b) == a + b, 1003);
    }

    /// Another function testing nested quantifiers with multiple where conditions and inferred literals
    public fun nested_fun(x: u64): u64 {
        x * 2
    }

    spec fun nested_fun(x: u64) {
        // Nested quantifiers, with where clauses filtering
        forall i: u64 where i < 5: {
            forall j: u64 where j < 3: {
                assert!(i + j < 10, 2000);
            };
        };
        // Check x less than max u64 value - 10
        assert!(x < 18446744073709551606, 2001);
        // Result correctness
        assert!(nested_fun(x) == x * 2, 2002);
    }

    /// Function with spec expecting signature mismatch to test detection
    public fun signature_mismatch_fun(x: u64): u64 {
        x
    }
    // The spec purposely has incorrect signature (u8 instead of u64) to expect failure in verification (simulation).
    // This is to test signature mismatch detection.
    // The test framework won't abort here but we still provide it.
    spec fun signature_mismatch_fun(x: u8) {
        assert!(x < 100, 3000);
    }

    /// Function testing inferred integer literal boundaries and runtime assertion
    public fun boundary_test(a: u128): u128 {
        // execute only assertion
        assert!(a < 340282366920938463463374607431768211456, 4000); // 2^128
        a
    }
    spec fun boundary_test(a: u128) {
        // Check a less than max u128 without explicit suffix, ensuring largest inferred integer
        assert!(a < 340282366920938463463374607431768211456, 4001);
    }

    /// Runner function to call all other test functions to drive coverage
    public fun runner() {
        let _ = spec_fun(123, 456);
        let _ = nested_fun(7);
        let _ = signature_mismatch_fun(10u64);
        let _ = boundary_test(123456789012345678901234567890u128);
    }
}


//# run 0xCAFE::AdvancedSpecTest::runner


//# run 0xCAFE::AdvancedSpecTest::spec_fun --args 5u64 15u64


//# run 0xCAFE::AdvancedSpecTest::nested_fun --args 8u64


//# run 0xCAFE::AdvancedSpecTest::signature_mismatch_fun --args 20u64


//# run 0xCAFE::AdvancedSpecTest::boundary_test --args 123456789012345678901234567890u128


// Featurres:
// d945dc417d77917518473d5006c670b6: Use 'where' clauses within quantifiers to specify conditions.
// e503ac8923db8e280a41f115de02ceb4: Attach specification blocks to individual module members (such as functions) and optionally provide their signatures for precise specification.
// c75d7359b63fbb705a37fec34c1e69b3: Use inferred-width integer literals in Move code (automatically using the largest integer type possible if no suffix is provided).
