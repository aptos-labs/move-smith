
//# publish
module 0xDEADBEEF::DiagnosticsTest {
    use std::vector;

    // Function with explicitly typed nested closures
    public fun outer_function(x: u8): u8 {
        // Define a nested closure with explicit return type
        let closure1: |u8| -> u8 = |a: u8| -> u8 {
            // Closure captures no variables
            let result = a + 1;
            result
        };

        // Define another nested closure calling closure1
        let closure2: |u8| -> u8 = |b: u8| -> u8 {
            let intermediate = closure1(b);
            // Modify intermediate
            let final_result = intermediate * 2;
            final_result
        };

        // Call closure2 with input
        let res = closure2(x);
        res
    }

    // Function with nested closure explicitly specifying argument and return types
    public fun inner_function(y: u16): u16 {
        let nested_closure: |u16| -> u16 = |a: u16| -> u16 {
            if (a > 10) {
                a - 10
            } else {
                a + 10
            }
        };
        // Call nested_closure with y
        let result = nested_closure(y);
        result
    }

    // Function that creates nested closures and explicitly destructures their return values
    public fun combined_closure(x: u8, y: u16): u16 {
        let double: |u8| -> u16 = |a: u8| -> u16 {
            (a as u16) * 2
        };
        let increment: |u16| -> u16 = |b: u16| -> u16 {
            b + 5
        };

        // Compose closures
        let c1 = double(x);
        let c2 = increment(c1);

        // Define a nested closure that returns multiple values explicitly
        let multiple_return_closure: |u8, u16| -> (u16, u16) = |a: u8, b: u16| -> (u16, u16) {
            let v1 = (a as u16) + b;
            let v2 = b * 2;
            (v1, v2)
        };

        let (val1, val2) = multiple_return_closure(x, y);
        // Use previous computations
        val2 + val1
    }

    // Function to output diagnostics (simulate display of diagnostics)
    public fun output_diagnostics() {
        // This function is intended to invoke diagnostics output
        // Usually, diagnostics are emitted during compilation
        // For testing, this might just be a placeholder
        // For the test environment, assume this triggers diagnostic display
        // (No-op in actual Move runtime)
        // Just indicating call site
        // Actual diagnostics would be captured/checked by the test harness
    }

    // Wrapper to call output_diagnostics
    public fun run_diagnostics() {
        output_diagnostics()
    }
}


//# run 0xDEADBEEF::DiagnosticsTest::run_diagnostics


// Featurres:
// 75ee3fa84956c120f08c2d91e03731db: Call `output_diagnostics` to display compiler diagnostics with source code context.
// e83f6a8bcd3956b69924e8227de41daa: Define function signatures with parameter and return types.
// e9e917f56944b7bf481e4622090aa4b1: Test that nested closures with explicit return types in Move can be created, returned, called, and destructured correctly.
