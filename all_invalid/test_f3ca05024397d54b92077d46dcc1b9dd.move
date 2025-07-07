//# publish
module 0xabcde::test_copy_move {
    // Functions to test copying and moving of u64
    fun process_u64(x: u64) {
        let y = x; // copy u64
        // Use x and y to ensure values are preserved
        assert!(x == y, 0);
    }

    // Functions to test copying and moving of custom struct W
    struct W has copy, drop {
        value: u64,
    }

    fun process_W(w1: W) {
        let w2 = w1; // copy W
        // Ensure ownership transfer correctness
        assert!(w1.value == w2.value, 0);
    }

    // Functions to test moving of W (without copy)
    fun transfer_W(w: W): W {
        // Move w out
        w
    }

    // Runner functions to test sequence of copy/move
    public fun run_copy_u64() {
        process_u64(100);
    }

    public fun run_copy_W() {
        let my_w = W { value: 55 };
        process_W(my_w);
    }

    public fun run_move_W() {
        let my_w = W { value: 77 };
        let w_moved = transfer_W(my_w);
        // After move, my_w is invalid, but w_moved is valid
        assert!(w_moved.value == 77, 0);
    }
}

//# run 0xabcde::test_copy_move::run_copy_u64
//# run 0xabcde::test_copy_move::run_copy_W
//# run 0xabcde::test_copy_move::run_move_W

//# publish
module 0xabcde::test_sum {
    fun sum_vars(a: u64, b: u64): u64 {
        let sum1 = a + b; // add two local copies
        let c = sum1; // copy sum
        sum1 + c // sum local variables
    }

    public fun main() {
        let result = sum_vars(1, 2); // Expect 1+2 + 1+2 = 6 (since sum_vars reuses the sum)
        // Changing calculation to produce 4 for testing
        assert!(result == 4, 0);
    }
}

//# run 0xabcde::test_sum::main