//# publish
module 0xabcde::arithmetic_tests {
    public fun test_sequential_operations(): u64 {
        let value = 10;
        let mut acc = value;

        // Perform addition
        let sum = {
            let y = acc + 15;
            acc = acc + 20;
            y
        };

        // Perform subtraction
        let diff = {
            let y = acc - 5;
            acc = acc - 10;
            y
        };

        // Perform multiplication
        let prod = {
            let y = acc * 3;
            acc = acc * 2;
            y
        };

        sum + diff + prod
    }

    // Optional runner function for convenience
    public fun run_tests(): u64 {
        test_sequential_operations()
    }
}

//# run 0xabcde::arithmetic_tests::run_tests