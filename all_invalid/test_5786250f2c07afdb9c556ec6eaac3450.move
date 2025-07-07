//# publish
module 0xabcde::accumulation_test {
    public fun test_sequential_accumulation(): u64 {
        let total = 0;
        let mut temp = total;
        // First sequence of updates
        temp = temp + 5;
        temp = temp + 10;
        let first_sum = temp; // 15

        // Reset temp
        temp = total;
        // Second sequence of updates
        temp = temp + 20;
        temp = temp + 30;
        let second_sum = temp; // 50

        // Final aggregation
        first_sum + second_sum
    }

    public fun run_test() {
        let result = Self::test_sequential_accumulation();
        // The total should be 15 + 50 = 65
        // No assertion needed for this test case
    }
}

//# run 0xabcde::accumulation_test::run_test