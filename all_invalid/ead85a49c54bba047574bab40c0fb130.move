// Corrected version of the transactional test module
module 0xCAFE::TransactionalTest {
    use std::vector;

    // Removed incorrect inline comments and fixed module syntax

    // Run test: lambda with ignored args
    public fun test_lambda_with_ignored_args() {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        let (c, d) = lambda(3u8, 4u8);
        // reuse lambda with ignored argument
        let _ = copy lambda;
        let (x, y) = lambda(5u8, 6u8);
        assert!(c == 7, 999);
        assert!(d == 12, 998);
        assert!(x == 11 && y == 30, 997);
    }

    // Run test: replace copy with move syntax
    public fun test_replace_copy_with_move() {
        let s = 42u8;
        let val = move s; // Moving s instead of copying, for syntax correctness
        assert!(val == 42, 996);
    }

    // Run test: reference global invariant
    public fun test_global_invariant_reference() {
        // Simulate referencing global invariants
        // For the purpose of this test, define a global invariant as a constant
        const GLOBAL_COUNT: u64 = 100;
        let ref_count = &GLOBAL_COUNT;
        assert!(*ref_count == 100, 995);
    }
}