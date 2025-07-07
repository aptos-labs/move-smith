//# publish
module 0xabcde::nested_var_test {
    public fun run_tests(): u64 {
        // Initialize variable
        let mut count = 0;

        // First nested block: increment count
        {
            count = count + 2;
            // Nested block inside first block
            {
                count = count + 3;
            }
            // After nested block
            count = count + 1;
        }
        // Second independent block
        {
            count = count + 4;
        }
        // Final return after all modifications
        count
    }
}

//# run 0xabcde::nested_var_test::run_tests
