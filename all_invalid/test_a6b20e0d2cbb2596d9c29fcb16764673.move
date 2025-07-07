//# publish
module 0xabcde::copy_move_test {
    // Function to test that passing u64 by value works correctly
    fun process_u64(val: u64) {
        // Dummy operation to prevent optimization removal
        let _ = val;
    }

    // Function to test that moving a u64 variable preserves ownership during function calls
    public fun move_u64(x: u64) {
        process_u64(x);
    }

    // Struct with copy and drop traits to test ownership transfer
    struct W has copy, drop {
        val: u64,
    }

    // Function to consume a W, which takes ownership
    fun consume_w(_w: W) {}

    // Function to test copying W and passing it multiple times
    public fun test_copy_w(w: W) {
        let w_copy = copy w;
        consume_w(w);
        consume_w(w_copy);
    }

    // Function to test moving W into multiple functions sequentially
    public fun test_move_w(w: W) {
        let w1 = w; // move w into w1
        consume_w(w1);
        // after move, w is no longer valid
    }

    // Runner function to test passing and moving u64 and W
    public fun run_tests() {
        let val: u64 = 123;
        process_u64(val); // pass by value

        move_u64(val); // move ownership of u64

        let my_w = W { val: 456 };
        test_copy_w(my_w); // copy and pass W

        let my_w2 = W { val: 789 };
        test_move_w(my_w2); // move W into function
    }
}

//# run 0xabcde::copy_move_test::run_tests --signers 0xabcde