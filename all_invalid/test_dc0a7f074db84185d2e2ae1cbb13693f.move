//# publish
module 0xABCD::ClosureTest {
    /// Inline function that accepts two closure arguments with different parameter configurations, and parameters to pass.
    inline fun combine<F1: |u64, u64| u64, F2: |u64, u64, u64| u64>(
        f1: &F1,
        f2: &F2,
        x: u64,
        y: u64,
        z: u64,
        w: u64
    ): u64 {
        // Execute the first closure with parameters
        let res1 = f1({x = x + 2; x}, {y = y + 2; y});
        // Execute the second closure with parameters
        let res2 = f2({x = z + 3; x}, {y = y + 3; y}, {z = w + 4; z});
        // Compute a combined result
        res1 * res2 + x + y + z + w
    }

    /// Function that tests different closure behaviors
    public fun test_combine() {
        // Call combine with two inline closures
        let result = combine(
            &|a: u64, b: u64| a + b,
            &|a: u64, b: u64, c: u64| a * b + c,
            5,
            10,
            15,
            20
        );
        assert!(result == 7020, result);
    }
}

//# run 0xABCD::ClosureTest::test_combine