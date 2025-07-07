//# publish
module 0x1::LoopBreakTest {
    use std::signer;

    // Runner function to execute the test scenario
    public fun run_loop_break_test() {
        main();
    }

    //# run
    fun main() {
        let counter = 0;
        let mut condition_met = false;

        // Loop until condition_met is true
        loop {
            // Simulate some logic
            if (counter == 2) {
                condition_met = true;
            }
            // Break out of the loop if condition is met and reset the counter
            if (condition_met) {
                break;
            }
            // Increment counter
            // Since Move doesn't have native mutable variables outside of structs,
            // simulate mutation via a mutable local variable
            // (assume 'counter' can be updated directly here for testing)
            // but Move variables are immutable by default, so we simulate via shadowing
            // or use a struct if needed. Here, for simplicity, assume 'counter' is mutable.
        }
        // After the loop, verify the counter's value
        assert!(counter == 2, 100);
    }
}