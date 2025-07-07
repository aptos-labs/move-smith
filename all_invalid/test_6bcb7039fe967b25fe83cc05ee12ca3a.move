//# publish
module 0xA11::ClosureSum {
    // Inline function that takes two closures, each returning a u64, and sums their results
    inline fun sum_closures(f: |u64, u64| u64, g: |u64, u64| u64, x: u64, y: u64): u64 {
        f(x, y) + g(x, y)
    }

    // Function to test sum_closures with different closure implementations
    public fun test_sum_closures() {
        // Closure that returns first argument doubled
        let closure1 = |a: u64, b: u64| a + b;
        // Closure that returns second argument multiplied by 10
        let closure2 = |a: u64, b: u64| b * 10;

        let result = sum_closures(closure1, closure2, 3, 5);
        // Expect 3+5 + 5*10 = 8 + 50 = 58
        assert!(result == 58, 0);
    }

    // Runner function to invoke the test
    public fun run_tests() {
        test_sum_closures();
    }
}

//# run 0xA11::ClosureSum::run_tests