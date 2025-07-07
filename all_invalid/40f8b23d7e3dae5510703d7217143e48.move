//# publish
module 0xCAFE::Identifier_Test {
    // Test 1: Various valid identifiers using ASCII letters, digits, and underscores
    struct _LeadingUnderscore has copy, drop, store, key {
        x: u64,
    }

    struct Mixed123_ABC has copy, drop, store, key {
        y: u8,
    }

    struct simple has copy, drop, store, key {
        z: bool,
    }

    // Custom compare function to be used in test 3
    public fun my_eq(a: u64, b: u64): bool {
        a == b
    }

    // Custom compare function with complex name allowed by identifiers rules
    public fun _CMP_42_isAnswer_(x: u8): bool {
        x == 42u8
    }

    // Runner function to call some functions (exercise callable function & semicolon usage)
    public fun runner() {
        // Create instances with semicolons at end

        let s1 = _LeadingUnderscore { x: 10u64 };
        let s2 = Mixed123_ABC { y: 42u8 };
        let s3 = simple { z: true };

        // Use semicolons at statement ends for assignment and calls
        let eq_result = my_eq(s1.x, 10u64);
        let cmp_result = _CMP_42_isAnswer_(s2.y);

        // Just to occupy the results, no assertions needed
        assert!(eq_result);
        assert!(cmp_result);
    }
}
//# run 0xCAFE::Identifier_Test::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::Identifier_Test;

    fun main() {
        // Create structs with various identifiers
        let inst1 = Identifier_Test::_LeadingUnderscore { x: 123u64 };
        let inst2 = Identifier_Test::Mixed123_ABC { y: 13u8 };
        let inst3 = Identifier_Test::simple { z: false };

        // Call custom compare functions
        let res1 = Identifier_Test::my_eq(inst1.x, 123u64);
        let res2 = Identifier_Test::_CMP_42_isAnswer_(inst2.y);

        // Use a semicolon at the end of the statement
        if (res1 && !res2) {
            // do nothing, just presence of control flow
        };
    }
}