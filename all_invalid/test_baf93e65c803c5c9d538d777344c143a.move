//# publish
module 0xabcde::test_module {
    // Increment function that modifies a mutable reference to a u64
    public fun inc(x: &mut u64): u64 {
        *x = *x + 1;
        *x
    }

    // Function to test multiple increments and their combined effect
    public fun test_increments(): u64 {
        let mut value = 5;
        let first = inc(&mut value); // value becomes 6
        let second = inc(&mut value); // value becomes 7
        first + second + value // 6 + 7 + 7 = 20
    }

    // Nested block bindings to swap and modify values, then compute total sum
    public fun test_blocks(): u64 {
        let a = 3;
        let b = 7;
        let total1 = {let (a_local, b_local) = (b, a + 2); a_local + b_local}; // 7 + 5 = 12
        let total2 = {let (a_local, b_local) = (b * 2, a - 1); b_local / a_local}; // (14 / 4) = 3
        total1 + total2 // 12 + 3 = 15
    }

    // Runner function to execute all tests
    public fun run_tests() {
        let inc_result = test_increments();
        let block_result = test_blocks();
        // For demonstration, print values (if desired), or just invoke the tests
        // For now, they can be used to verify correctness via assertions outside
    }
}

//# run 0xabcde::test_module::run_tests