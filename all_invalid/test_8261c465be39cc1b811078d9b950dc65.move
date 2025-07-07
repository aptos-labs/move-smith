//# publish
module 0xabcde::loop_tests {
    // Function to test nested while loops with variable updates and preserving values
    public fun nested_loop_test(limit: u64, start: u64): u64 {
        let total: u64 = 0;
        let outer = 0;
        let mut inner: u64;
        let mut i = start;

        while (i < limit) {
            inner = i;
            let mut j = 0;

            while (j < 3) {
                inner = inner + j;
                j = j + 1;
            }

            total = total + inner;
            i = i + 1;
        };
        total
    }

    // Function to test while loop with variable reassignment and increment
    public fun reassign_and_break(x: u64): u64 {
        let mut count = 0;
        let mut accumulator = 0;

        while (count < x) {
            if (count == x / 2) {
                // Reassign accumulator mid-loop
                accumulator = 999;
                break;
            }
            accumulator = accumulator + count;
            count = count + 1;
        };
        accumulator
    }

    // Runner function for nested_loop_test
    public fun run_nested_loop_test(): u64 {
        nested_loop_test(10, 2)
    }

    // Runner function for reassign_and_break
    public fun run_reassign_and_break(): u64 {
        reassign_and_break(8)
    }
}

//# run 0xabcde::loop_tests::run_nested_loop_test --signers 0x1 --args
//# run 0xabcde::loop_tests::run_reassign_and_break --signers 0x1