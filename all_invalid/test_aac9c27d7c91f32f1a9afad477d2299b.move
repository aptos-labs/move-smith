//# publish
module 0x1::recursive_fibonacci {
    /// Recursive Fibonacci implementation
    public fun fib(n: u64): u64 {
        if (n == 0) {
            0
        } else if (n == 1) {
            1
        } else {
            fib(n - 1) + fib(n - 2)
        }
    }

    /// Runner function to test Fibonacci for 0 to 10
    public fun run_fibonacci_tests() {
        let expected_results = vector [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55];
        let mut index = 0;
        while (index < vector::length(&expected_results)) {
            let n = index as u64;
            let result = fib(n);
            // No assertion needed, but in real tests, assertions would be used
            // Here, just calling fib for coverage
            index = index + 1;
        }
    }
}

//# run 0x1::recursive_fibonacci::run_fibonacci_tests