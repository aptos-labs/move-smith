//# publish
module 0x1::VariableShadowingTest {
    use std::debug;

    // Entry point for the test
    public fun run_test() {
        // Variable outside the loop
        let counter: u64 = 0;

        // While loop with variable shadowing
        while (counter < 3) {
            // Shadowed variable inside the loop
            let counter: u64 = counter + 1;
            debug::print(&"Inside loop: ");
            debug::print(&counter);
        }

        // After the loop, check the value of the outer variable
        debug::print(&"After loop, counter: ");
        debug::print(&counter); // should be 0, as original variable

        // Test variable shadowing across iterations
        assert!(counter == 0, 42, "Outer counter should remain 0");
    }
}
