
//# publish
module 0xDEAD::TestAssignments {
    use std::assert;

    // Function that attempts to change its parameter inside the inline lambda
    public fun update_param_in_lambda(x: u8): u8 {
        let lambda: |u8| -> u8 = |param: u8| {
            let local_param = param;
            local_param = 42;
            local_param
        };
        // Call lambda with x
        let result = lambda(x);
        result
    }

    // Function that assigns explicit values to local variables using Assign expressions
    public fun assign_values(): (u8, u8, u8) {
        let a = 10;
        let b = 20;
        let _ = {
            let a = 30;
            let b = 40;
        };
        // Returning original a and b to verify they are unchanged
        (a, b, a + b)
    }

    // Function with a loop that breaks immediately
    public fun loop_break_once(): u64 {
        let x = 0u64;
        let counter = x;
        loop {
            if (true) {
                counter = 999u64;
                break;
            };
        };
        counter
    }

    // Runner function to execute the above tests
    public fun run_tests() {
        // Test 1: Check that parameter inside lambda does not affect caller's variable
        let param = 7u8;
        let res = update_param_in_lambda(param);
        // res should be 42, param remains 7
        assert!(res == 42, 1);
        assert!(param == 7, 2);

        // Test 2: Assignment expressions to variables
        let (a_val, b_val, sum) = assign_values();
        assert!(a_val == 10, 3);
        assert!(b_val == 20, 4);
        assert!(sum == 30, 5);

        // Test 3: Loop with break
        let result = loop_break_once();
        assert!(result == 999u64, 6);
    }
}


//# run 0xDEAD::TestAssignments::run_tests


// Featurres:
// 00905dd3d71fdef5877e9eb8e033622f: Test that assignments to a function parameter inside an inline function do not affect the original argument in the caller's scope.
// f4e30cc9e9519cf1b7ee32cdb8f66aa8: Assign values to variables with `Assign` expressions.
// 9d6fa7bbdf4ee46cd979039566ac14fa: Test that a loop with an immediate break correctly executes once and updates the variable accordingly.
