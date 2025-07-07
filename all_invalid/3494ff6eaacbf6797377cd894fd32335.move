//# publish
module 0xA550C3D62D5A4186::test_module {
    // Module to test sum computation and move pattern matching
    use std::debug;

    // Runner function to execute main
    public fun run_main() {
        Self::main();
    }

    // Main function to compute sum and perform assertion
    public fun main() {
        let a: u64 = 10;
        let b: u64 = 20;
        let c: u64 = 30;
        let total: u64 = a + b + c;

        // Assert that total equals 60 (the sum of a, b, c)
        // For demonstration, the assertion is logically always true here
        assert!(total == 60, 42);

        // Demonstration of move match with '..' pattern (destructuring)
        let tuple_value = (1, 2, 3, 4, 5);
        match tuple_value {
            (first, .., last) => {
                debug::print(&first);
                debug::print(&last);
            }
        };
    }
}
//# run 0xA550C3D62D5A4186::test_module::run_main