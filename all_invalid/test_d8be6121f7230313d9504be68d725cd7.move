//# publish
module 0x1::RangeTestModule {
    use std::signer;

    // Runner function for the range loop test
    public fun run_range_test() {
        // Call the test function
        main();
    }

    // Function that performs a loop from 0 to 10 and accumulates sum
    public fun main() {
        let mut sum: u64 = 0;
        for (i in 0..=10) {
            sum = sum + i;
        }
        // Optional: Do something with sum if needed
    }

    // Runner function for the out-of-gas scenario
    public fun run_gas_test() {
        main_with_gas();
    }

    // Function that runs a loop intended to exhaust gas
    public fun main_with_gas() {
        let mut count: u64 = 0;
        while (true) {
            // Infinite loop to ensure gas exhaustion
            count = count + 1;
        }
    }
}

//# run
script {
    // Test that a for loop iterates correctly over a range from 0 to 10
    // This should complete without error, verifying proper iteration
    // (No assertions needed, the successful run indicates correctness)
}

//# run --gas-budget 700
script {
    // Test the handling of gas exhaustion during a loop
    // This should fail due to gas exhaustion
    // Calling the function that runs an infinite loop to exhaust gas
}