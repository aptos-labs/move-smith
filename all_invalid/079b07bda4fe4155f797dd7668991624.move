


//# run 0xCAFE::MyModule::f1 --args 5u8 false


//# run 0xCAFE::MyModule::f3 --args 20u16


//# publish
module 0xCAFE::NestedLoopTest {
    use std::vector;

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
        y
    }

    // Helper function with a unique name to test multiple functions
    public fun unique_function_name() {
        // Call nested_loop_accumulate with a specific input
        let result = nested_loop_accumulate(10u8);
        // Could be used for assertions or further logic in tests
        result
    }
}


//# run 0xCAFE::NestedLoopTest::nested_loop_accumulate --args 0u8


//# run 0xCAFE::NestedLoopTest::unique_function_name


// Featurres:
// 70d36c24f173aae55b1f416f307e2744: Use unit types in your type signatures and let the compiler handle them appropriately.
// 0ee68b8b1ecbb2d5bb01cb30af43a4aa: Test that nested loops correctly accumulate the value of `y`, resulting in a final count of 65, ensuring loop iteration and variable updates behave as expected.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
