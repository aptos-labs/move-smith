//# publish
module 0x7e::ResourceTest {
    // Define a resource with a simple inner value.
    struct S has key {
        value: u64,
    }

    // Function that borrows the resource immutably and returns its value.
    public fun get_value(r: &S): u64 {
        r.value
    }

    // Function that stores a resource in the account, borrows it immutably,
    // and asserts the value is as expected.
    public fun test_resource_access(s: &signer) acquires S {
        move_to<S>(s, S { value: 42 });
        let s_ref = borrow_global<S>(@0x7e);
        let val = get_value(&s_ref);
        assert!(val == 42, 100);
    }
}

//# run --signers 0x7e
script {
    use 0x7e::ResourceTest;
    fun main(account: &signer) {
        ResourceTest::test_resource_access(account)
    }
}

//# publish
module 0x7e::LoopTest {
    // Test that a loop with both break and continue updates the variable correctly.
    public fun loop_with_break_and_continue(s: &signer) {
        let mut count = 0;
        let mut i = 5;

        while (i > 0) {
            if (i == 3) {
                // Skip the current iteration when i == 3
                i = i - 1;
                continue;
            }
            if (i == 1) {
                break;
            }
            count = count + i;
            i = i - 1;
        }
        // After loop, count should be sum of 5 + 4 + 2 + 1 (since 3 was skipped, 1 breaks)
        // So count = 5 + 4 + 2 + 1 = 12
        assert!(count == 12, 200);
    }
}

//# run --signers 0x7e
script {
    use 0x7e::LoopTest;
    fun main(account: &signer) {
        LoopTest::loop_with_break_and_continue(account)
    }
}

//# publish
module 0x7e::SwapExample {
    // Test that a function swaps two values based on iterations and correctness of the swap.
    public fun swap_iter(x: u64, y: u64, iterations: u64): (u64, u64) {
        let mut a = x;
        let mut b = y;
        let mut i = iterations;

        while (i > 0) {
            // Swap a and b
            let temp = a;
            a = b;
            b = temp;
            i = i - 1;
        }
        (a, b)
    }

    // Function that uses swap_iter to swap values multiple times based on input.
    public fun main() {
        let (swap_x, swap_y) = swap_iter(10, 20, 3);
        // After 3 swaps, values should be back to original values.
        assert!(swap_x == 10, 300);
        assert!(swap_y == 20, 300);

        let (swap_x2, swap_y2) = swap_iter(5, 15, 1);
        // After 1 swap, values are swapped once.
        assert!(swap_x2 == 15, 301);
        assert!(swap_y2 == 5, 301);
    }
}

//# run 0x7e::SwapExample::main