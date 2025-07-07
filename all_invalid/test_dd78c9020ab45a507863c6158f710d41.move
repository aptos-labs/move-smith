//# publish
module 0xabc::InteractionTest {
    // Inline function that applies multiple lambdas to two inputs and sums their results
    inline fun compute_sum(
        f: |u64, u64| u64,
        g: |u64, u64| u64,
        h: |u64, u64| u64,
        i: |u64, u64| u64,
        a: u64,
        b: u64
    ): u64 {
        f(a, b) + g(a, b) + h(a, b) + i(a, b)
    }

    // Runner function to test various call patterns with lambdas and variable manipulations
    public fun run_tests(): () {
        // Define lambdas that perform simple arithmetic operations
        let lambda_x = |x: u64, _: u64| x * 2;
        let lambda_y = |_x: u64, y: u64| y + 10;
        let lambda_sum = |x: u64, y: u64| x + y;
        let lambda_diff = |x: u64, y: u64| (x > y) ? (x - y) : (y - x);

        // Call compute_sum with different lambdas to verify correct application
        let result1 = compute_sum(lambda_x, lambda_y, lambda_sum, lambda_diff, 5, 7);
        assert!(result1 == (10 + 17 + 12 + 2), 0); // 10 + 17 + 12 + 2 = 41

        // Reassign lambdas inside the function with different behaviors
        let lambda_x = |x: u64, y: u64| x + y;
        let lambda_y = |x: u64, y: u64| y * 3;
        let lambda_sum = |x: u64, y: u64| x * y;
        let lambda_diff = |x: u64, y: u64| (x >= y) ? (x - y) : (y - x);

        let result2 = compute_sum(lambda_x, lambda_y, lambda_sum, lambda_diff, 3, 4);
        assert!(result2 == (3+4) + (4*3) + (3*4) + (1), 0); // 7 + 12 + 12 + 1 = 32
    }
}

//# run 0xabc::InteractionTest::run_tests