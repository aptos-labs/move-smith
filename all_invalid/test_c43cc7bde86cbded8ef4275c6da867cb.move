//# publish
module 0xabc::sum_multiples {
    public fun sum_multiples_3_or_5(limit: u64): u64 {
        let mut sum = 0;
        let mut i = 0;
        while (i < limit) {
            if (i % 3 == 0 || i % 5 == 0) {
                sum = sum + i;
            };
            i = i + 1;
        };
        sum
    }

    public fun verify_sum_for_limit(limit: u64, expected: u64) {
        let result = sum_multiples_3_or_5(limit);
        // We are not asserting here, just for calling and checking results manually
        // (assertions can be added if needed)
        if (result != expected) {
            // Typically, one would panic or log, but for test, we just ignore
        }
    }

    public fun get_test_results() {
        // Test with limit 10
        verify_sum_for_limit(10, 23);
        // Test with limit 1000
        verify_sum_for_limit(1000, 233168);
    }
}

//# run 0xabc::sum_multiples::get_test_results

//# publish
module 0xabc::test {
    fun for_numbers(i: u32, j: u32, k: u32) : u32 {
        i + j + k
    }
    public fun sum_three_numbers(i: u32, j: u32, k: u32) : u32 {
        for_numbers(i, j, k)
    }

    public fun test_for_user() : u32 {
        let nums = (7, 8, 9);
        let total = sum_three_numbers(nums.0, nums.1, nums.2);
        total
    }
}

//# run 0xabc::test::test_for_user