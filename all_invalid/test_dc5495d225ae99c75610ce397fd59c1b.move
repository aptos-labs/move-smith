//# publish
module 0xc0ffee::test_immutable {
    fun try_reassign(x: u64): u64 {
        let y = x;
        y = y + 1; // Should cause an error: reassigning an immutable variable
        y
    }

    public fun main() {
        // This line is expected to fail compilation due to reassignment
        // but since assertions are ignored, it's here for completeness
        let _result = try_reassign(10);
    }
}

//# run 0xc0ffee::test_immutable::main

//# publish
module 0xc0ffee::test_swap_iterations {
    public fun run_swap(x: u64, y: u64, iterations: u64): (u64, u64) {
        let mut a = x;
        let mut b = y;
        let mut i = iterations;
        while (i > 0) {
            let temp = a;
            a = b;
            b = temp;
            i = i - 1;
        };
        (a, b)
    }

    public fun main() {
        let (start_x, start_y) = (3, 7);
        let iterations = 5;
        let (final_x, final_y) = run_swap(start_x, start_y, iterations);
        // After odd number of swaps, values should be swapped
        // For 5 iterations, final_x should be start_y, final_y should be start_x
        assert!(final_x == start_y, 0);
        assert!(final_y == start_x, 1);
    }
}

//# run 0xc0ffee::test_swap_iterations::main