//# publish
module 0xdeadbeef::multi_abort_test {
    public fun abort_if_even(n: u64): u64 {
        if (n % 2 == 0) {
            abort 42; // abort for even numbers
        }
        n
    }

    public fun process_numbers() : u64 {
        let mut result = 0;
        let nums = vector[1u64, 2u64, 3u64, 4u64, 5u64]; // sample vector
        let len = vector::length(&nums);
        let mut i = 0;
        while (i < len) {
            // Try processing each number with possible abort
            let n = *vector::borrow(&nums, i);
            result = result + if (n % 2 == 0) {
                // handle aborts by catching exceptions
                // move to simulate catch; in Move catch is not explicit but for the test, assume aborts are caught
                // We simulate by calling abort_if_even which aborts for evens
                abort_if_even(n)
            } else {
                n
            };
            i = i + 1;
        }
        result
    }

    // Runner function to trigger test
    public fun run_all() {
        Self::process_numbers();
    }
}

//# run --verbose --signers 0xdeadbeef -- 0xdeadbeef::multi_abort_test::run_all