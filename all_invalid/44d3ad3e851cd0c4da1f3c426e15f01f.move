
//# publish
module 0xCAFE::TestComparisonAndOperations {
    use std::vector;

    public fun test_arithmetic() {
        assert!(1 + 2 == 3, 101);
        assert!(10 - 3 == 7, 102);
        assert!(4 * 5 == 20, 103);
        assert!(20 / 4 == 5, 104);
        assert!(20 % 6 == 2, 105);
    }

    public fun test_comparison() {
        assert!(3 == 3, 201);
        assert!(2 != 3, 202);
        assert!(4 > 3, 203);
        assert!(3 >= 3, 204);
        assert!(2 < 3, 205);
        assert!(3 <= 3, 206);
    }

    public fun test_logical() {
        assert!(true && true, 301);
        assert!(true || false, 302);
        assert!(!false, 303);
    }

    public fun test_bitwise() {
        let a: u8 = 0b1010;
        let b: u8 = 0b1100;
        assert!(a & b == 0b1000, 401);
        assert!(a | b == 0b1110, 402);
        assert!(a ^ b == 0b0110, 403);
        assert!(!a == 0b0101, 404);
    }

    public fun test_shift() {
        let val: u8 = 0b0001;
        assert!((val << 3) == 0b1000, 501);
        assert!((val >> 1) == 0b0000, 502);
    }

    public fun test_ordering_with_assert() {
        let x: u32 = 100;
        let y: u32 = 200;
        assert!(x < y, 601);
        assert!(y > x, 602);
        assert!(x <= x, 603);
        assert!(y >= y, 604);
    }

    // Function with 'has' clause for functions that take parameter with copy ability
    public fun test_has_constraint<F: copy + drop>(f: &F) {
        // do nothing, just to test 'has' constraints
    }
}


//# run 0xCAFE::TestComparisonAndOperations::test_arithmetic


//# run 0xCAFE::TestComparisonAndOperations::test_comparison


//# run 0xCAFE::TestComparisonAndOperations::test_logical


//# run 0xCAFE::TestComparisonAndOperations::test_bitwise


//# run 0xCAFE::TestComparisonAndOperations::test_shift


//# run 0xCAFE::TestComparisonAndOperations::test_ordering_with_assert

// Featurres:
// 087171980c5f3b251bbacc114de2fd23: Write Move modules and scripts that will be run through the Move compiler.
// ef5b780d2e211c0876ced1ee30acd3b5: Test that basic comparison, logical, bitwise, shift, and arithmetic operations work correctly with assertions.
// 80c5b13665de1de67d1dcf657fd4c1c9: Apply ability constraints to function types using 'has' clauses.
