
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Testing skip attributes and critical edge optimizations
    // skip(
        lint_unused_variables,
        lint_unused_imports,
        lint_dead_code,
        lint_unreachable_code,
        lint_trailing_semicolon
    )]
    public fun swap_and_return(a: u64, b: u64): (u64, u64) {
        // Critical edge split example: using if-else to force the creation of edges
        if (a > b) {
            let temp = a;
            let a_new = b;
            let b_new = temp;
            (a_new, b_new)
        } else {
            let temp = b;
            let a_new = a;
            let b_new = temp;
            (a_new, b_new)
        }
    }

    // Function to test swapping two u64 values
    public fun test_swap() {
        let val1 = 100u64;
        let val2 = 200u64;
        let (swapped1, swapped2) = swap_and_return(val1, val2);
        // Use swapped values, but no assertions as per guidelines
        swapped1;
        swapped2;
    }

    // Function to perform another critical edge and branching example
    public fun complex_control_flow(x: u64): (u64, u64) {
        let _a;
        let _b;
        if (x % 2 == 0) {
            _a = x;
            _b = x / 2;
        } else {
            _a = x + 1;
            _b = x + 2;
        };
        (_a, _b)
    }
}




//# run 0xDEAD::TestModule::test_swap


// Features:
// 0e7641c7be14eddbfc10d5c5ff9b6a45: Skip specific lint checks for your code by listing their names in the // skip(...)] attribute.
// 3d5cb9ee90011cf788bdec4f515741a7: Use critical edge splitting to simplify control flow for optimization passes.
// f9da88c6c81c8d4842f9cfc49e241d70: Test swapping two u64 values and returning them as a tuple from a function.
