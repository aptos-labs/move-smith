//# publish
module 0xCAFE::IdentifierTest {
    // Test 1: Various valid identifiers using ASCII letters, digits, and underscores
    struct LeadingUnderscore has copy, drop, store, key {
        x: u64,
    }

    struct Mixed123ABC has copy, drop, store, key {
        y: u8,
    }

    struct Simple has copy, drop, store, key {
        z: bool,
    }

    // Custom compare function to be used in test 3
    public fun my_eq(a: u64, b: u64): bool {
        a == b
    }

    // Custom compare function with complex name allowed by identifiers rules
    public fun CMP_42_isAnswer(x: u8): bool {
        x == 42u8
    }

    // Runner function to call some functions (exercise callable function & semicolon usage)
    public fun runner() {
        // Create instances with semicolons at end

        let s1 = LeadingUnderscore { x: 10u64 };
        let s2 = Mixed123ABC { y: 42u8 };
        let s3 = Simple { z: true };

        // Use semicolons at statement ends for assignment and calls
        let eq_result = my_eq(s1.x, 10u64);
        let cmp_result = CMP_42_isAnswer(s2.y);

        // Just to occupy the results, no assertions needed
        assert!(eq_result);
        assert!(cmp_result);
    }
}
//# run 0xCAFE::IdentifierTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::IdentifierTest;

    fun main() {
        // Create structs with various identifiers
        let inst1 = IdentifierTest::LeadingUnderscore { x: 123u64 };
        let inst2 = IdentifierTest::Mixed123ABC { y: 13u8 };
        let inst3 = IdentifierTest::Simple { z: false };

        // Call custom compare functions
        let res1 = IdentifierTest::my_eq(inst1.x, 123u64);
        let res2 = IdentifierTest::CMP_42_isAnswer(inst2.y);

        // Use a semicolon at the end of the statement
        if (res1 && !res2) {
            // do nothing, just presence of control flow
        };
    }
}