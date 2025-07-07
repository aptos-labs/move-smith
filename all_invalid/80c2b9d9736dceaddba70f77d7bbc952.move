
//# run 0xCAFE::MyModule::f1 --args 5u8 false



//# run 0xCAFE::MyModule::f3 --args 20u16



//# publish
module 0xCAFE::NestedLoopTest {
    // Removed unused alias
    // use std::vector;

    // Function with nested loops to accumulate a value in `y`, ending with 65
    public fun nested_loop_accumulate(x: u8): u8 {
        let y = 0;
        let i = 0;
        // Outer loop, runs 5 times
        while (i < 5) {
            let j = 0;
            // Inner loop, runs 13 times (0 to 12)
            while (j < 13) {
                y = y + 1;
                j = j + 1;
            };
            i = i + 1;
        };
        y // Return the value of y (correctly as expression statement)
    }

    // Helper function with a unique name to test multiple functions
    public fun unique_function_name() {
        // Call nested_loop_accumulate with a specific input
        let result = nested_loop_accumulate(10u8);
        // Using the result for further logic isn't necessary if not used
        // but to fix the compilation error, the last line must be an expression
        result
    }
}



//# run 0xCAFE::NestedLoopTest::nested_loop_accumulate --args 0u8



//# run 0xCAFE::NestedLoopTest::unique_function_name
