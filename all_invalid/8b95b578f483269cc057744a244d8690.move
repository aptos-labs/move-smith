
//# publish
module 0xCAFE::ComparisonTests {
    use std::assert;

    // Custom struct with two u64 fields
    struct U64Pair has copy, drop, store {
        a: u64,
        b: u64,
    }

    // Comparison function for u64 values
    public fun compare_u64s(x: u64, y: u64): bool {
        x == y
    }

    // Comparison function for U64Pair structs
    public fun compare_u64pair(p1: &U64Pair, p2: &U64Pair): bool {
        p1.a == p2.a && p1.b == p2.b
    }

    // Unit test: compare simple u64 values
    // test]
    fun test_compare_u64_equal() {
        assert!(compare_u64s(42, 42), 1);
    }

    // test]
    fn test_compare_u64_inequal() {
        assert!(!compare_u64s(42, 43), 2);
    }

    // Unit test: compare structs for equality and inequality
    // test]
    fun test_compare_u64pair_equal() {
        let p1 = U64Pair { a: 10, b: 20 };
        let p2 = U64Pair { a: 10, b: 20 };
        assert!(compare_u64pair(&p1, &p2), 3);
    }

    // test]
    fn test_compare_u64pair_unequal() {
        let p1 = U64Pair { a: 10, b: 20 };
        let p2 = U64Pair { a: 15, b: 20 };
        assert!(!compare_u64pair(&p1, &p2), 4);
    }

    // Spec function: test comparison behavior
    public fun test_equality_spec() {
        let p1 = U64Pair { a: 1, b: 2 };
        let p2 = U64Pair { a: 1, b: 2 };
        assert!(compare_u64pair(&p1, &p2), 5);

        let p3 = U64Pair { a: 3, b: 4 };
        let p4 = U64Pair { a: 4, b: 3 };
        assert!(!compare_u64pair(&p3, &p4), 6);
    }
}


//# run 0xCAFE::ComparisonTests::test_compare_u64_equal --test

//# run 0xCAFE::ComparisonTests::test_compare_u64_inequal --test

//# run 0xCAFE::ComparisonTests::test_compare_u64pair_equal --test

//# run 0xCAFE::ComparisonTests::test_compare_u64pair_unequal --test

//# run 0xCAFE::ComparisonTests::test_equality_spec --test


// Featurres:
// 7adce3d4b2624780062b8f23dc554916: Use unit testing features via functions filtered by 'filter_test_members'.
// 03c60ac174e683c8896c630039c7b951: Verify that the equality functions correctly compare u64 values and custom struct instances with a u64 field.
// 8ca5154684fda1d15a08e50f89100d0e: Declare named spec functions inside spec blocks targeted at the module.
