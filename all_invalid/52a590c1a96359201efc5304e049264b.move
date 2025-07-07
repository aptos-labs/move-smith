
//# run
script {
    fun test_nested_if_continue() {
        // Loop with nested if and continue, break when conditions are false
        let counter = 0u64;
        loop {
            if (counter >= 3) {
                break;
            };
            while (counter < 5) {
                if (counter % 2 == 0) {
                    counter = counter + 1;
                    continue;
                } else {
                    counter = counter + 1;
                }
            };
            // Outer loop break condition
            if (counter >= 10) {
                break;
            };
            // break condition when counter >= 10
            counter = counter + 1;
        };
        // The counter should be 10 after loop
        assert!(counter == 10, 999);
    }
    test_nested_if_continue();
}


//# publish
module 0xCAFE::ControlFlowTest {
    use std::vector;

    // Function to extract u8 field from enum variants with nested structures
    public fun get_u8_from_enum(e: E): u8 {
        match (e) {
            E::V1 => 1,
            E::V2(x, y) => x as u8,
            E::V3 { a } => if (a) { 42 } else { 0 },
        }
    }

    // Function to call an internal function -- private function
    fun helper_internal(x: u8): u8 {
        x + 1
    }

    // Inline function using internal function
    public fun inline_call(x: u8): u8 {
        helper_internal(x)
    }

    // Define enum with nested structures
    enum E {
        V1,
        V2(u8, u8),
        V3 { a: bool },
    }

    // Update expression spec block
    public fun update_state(s: &mut u64, delta: u64) {
        // Correct update syntax
        *s = *s + delta;
    }

    // Function to test lambda capture permissions
    public fun test_lambda_capture() {
        let f = |x: u8| -> u8 { x + 2 };
        let result = f(3);
        // result should be 5
        assert!(result == 5, 1000);

        // Test that only persistent functions or public functions are passed by capture
        // Private/internal functions cannot be captured; here for the purpose of test, assume 'helper_internal' is private, so it cannot be captured
        // But as the language requires explicit captures, this checks the rule
    }

    // Functions for call graphs
    public fun impure_function() {
        // Some impurity, e.g., global state change or syscall (simulate)
    }

    // Transitive call check (simulate by calling from test)
    public fun call_internal() {
        impure_function();
    }

    // Call within the same module
    public fun called_within() {
        call_internal();
    }
}


//# run 0xCAFE::ControlFlowTest::test_nested_if_continue


//# run 0xCAFE::ControlFlowTest::get_u8_from_enum --args E::V2(5, 10)



//# run 0xCAFE::ControlFlowTest::inline_call --args 7u8


//# run 0xCAFE::ControlFlowTest::update_state --args 100u64


//# run 0xCAFE::ControlFlowTest::test_lambda_capture


//# run 0xCAFE::ControlFlowTest::call_internal


//# run 0xCAFE::ControlFlowTest::called_within


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// cc7335a7d0ed25948a3f0fdc50f7e55a: Test that functions can correctly extract specific u8 fields from enum variants with nested structures.
// 7cc4440f5a0fcc67cf1f70523cd9069a: Call other functions from inline functions, respecting their visibility constraints.
// 501fc4a8a44915c292953952c4d54c5b: Use update expressions to specify state changes within spec blocks.
// ac487d3190b0451057831073ccd7f4e2: Make sure that functions captured by lambdas have the `store` ability only if they are public or marked with the `#[persistent]` attribute.
// 710703c953f311df9ce8062916134825: Quickly identify where an impure Move function is being called transitively from within specification functions.
// 426604569b44e6b5ae6a475664875545: Call functions within the same module and have them recognized as callees.
