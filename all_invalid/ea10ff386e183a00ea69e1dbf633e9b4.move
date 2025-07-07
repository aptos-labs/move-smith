//# publish
module 0x1::MyTestModule {
    use std::debug;

    // Define an internal function (restricted to this module)
    internal fun process_value(value: u64): u64 {
        // Some internal processing
        value + 1
    }

    // Public script entry point for testing
    public fun run_test() {
        let counter: u64 = 0;

        // Variable outside the loop
        let result: u64 = 0;

        // Loop to test variable handling and shadowing
        while (counter < 5) {
            // Local variable inside the loop, shadows no variables
            let temp: u64 = counter * 2;

            // Use internal function
            result = process_value(temp);

            debug::print(&result);

            // Increment counter
            counter = counter + 1;
        }

        // After loop, ensure variables are correct
        // For example, check final values or perform assertions
        // (Assertions are not available in standard Move, but can be simulated)
    }
}
