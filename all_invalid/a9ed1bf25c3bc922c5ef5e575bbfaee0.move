
//# publish
module 0xCAFE::TransactionalTest {
    use std::vector;

    
//# run
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

    
//# run
    public fun test_replace_copy_with_move() {
        let s = 42u8;
        let val = copy s; // Should be replaced with move syntax, but tests for syntax correctness only
        assert!(val == 42, 996);
    }

    
//# run
    public fun test_global_invariant_reference() {
        // Simulate referencing global invariants
        // For the purpose of this test, we define a global invariant as a constant
        const GLOBAL_COUNT: u64 = 100;
        let ref_count = &GLOBAL_COUNT;
        assert!(*ref_count == 100, 995);
    }
}

// Featurres:
// 5fe160ed1eb9fc8c1f833320b14d8fc7: Test that lambda (anonymous function) parameters can be used with ignored arguments (using `_`) in inline function calls.
// db4d4284e8961f2d829ad3d54404f92d: Replace 'copy(x)' with 'copy x' to adhere to Move syntax conventions.
// 31339dd99238e13add680fcfd365beb5: Reference memory used in global invariants to ensure correct usage in your specifications.
