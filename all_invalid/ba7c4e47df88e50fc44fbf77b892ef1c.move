
//# publish
module 0xBADD::TestCompilerExit {
    // This module is designed to trigger compiler diagnostics with severity higher than Warning,
    // and to test literal expressions, nested function values, and function composition.

    // Helper function for arithmetic operations
    public fun add_u32(a: u32, b: u32): u32 {
        a + b
    }

    // Helper function for nested function capturing variables
    public fun capture_and_add(capture: u32): fun (u32) -> u32 {
        fun (x: u32): u32 {
            // Inside nested function, perform arithmetic with captured variable
            capture + x
        }
    }

    // Composition function
    public fun compose_with_capture(val1: u32, val2: u32): u32 {
        let f = capture_and_add(val1);
        let result = f(val2);
        result
    }

    // Entry function to execute the test
    public fun run_tests() {
        // Trigger compilation diagnostics with high severity with non-standard literals
        let _literal_value: u32 = value 4294967295u32; // Max u32 value literal
        let _another_literal: u8 = value 255u8;
        let _large_u128: u128 = value 123456789012345678901234567890u128;

        // Test nested function with captures
        let capture_value = 100u32;
        let sum_result = compose_with_capture(capture_value, 23u32);
        // sum_result should be 123
        // No assertions, focus is on compiler and VM execution

        // Test function that performs addition
        let sum = add_u32(10u32, 20u32);
        // sum should be 30
        // No assertions
    }
}


//# run 0xBADD::TestCompilerExit::run_tests


// Featurres:
// f48f01c31a1fbec319be6b03a383a9bf: Trigger compiler exit on diagnostics with severity higher than Warning.
// ff513cd37aa928903aae1b007537a562: Create value expressions using literals with the `value` expression.
// 193eac7d1e83e8ed9a345aa9b71f7f43: Test that nested function values with captured variables correctly perform arithmetic operations and that function composition with captures produces expected results.
