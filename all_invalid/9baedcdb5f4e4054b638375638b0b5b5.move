
//# publish
module 0xCAFE::ErrorHandlingTest {
    use std::vector;

    // Function that always aborts with a custom error code
    public fun trigger_abort() {
        abort 999;
    }

    // Function that catches aborts (simulate error checking)
    public fun check_error(status: u64): bool {
        status != 0
    }

    // Function to test detailed error message propagation
    public fun test_error_message() {
        let res = catch (trigger_abort()) {
            true
        };
        // 'res' will be false due to abort
        // For purpose of test, just return res
        res
    }

    // Function that tests variable assignment in a lambda, with shadowing
    public fun shadow_variable_in_lambda() {
        let outer_var = 100;
        let result = 0;

        let assign_in_lambda = |x: u64| {
            // Shadow outer `outer_var`
            let outer_var = x as u64;
            outer_var
        };

        let new_value = assign_in_lambda(42);
        // Assign to result using the lambda's inner variable
        result = new_value;
        // raising to prevent unused warning
        result
    }

    // Function that tests tuple field access syntax (.0, .1) with Move 2
    public fun test_tuple_field_access() {
        let tup = (10u64, 20u64);
        let a = tup.0; // should access first element
        let b = tup.1; // second element
        (a, b)
    }
}


//# run 0xCAFE::ErrorHandlingTest::test_error_message


//# run 0xCAFE::ErrorHandlingTest::shadow_variable_in_lambda


//# run 0xCAFE::ErrorHandlingTest::test_tuple_field_access

// Featurres:
// 5096a1acafda75408ede7e73f6a2359f: Provide Detailed Error Messages Including Error Status and Location
// 0a56f083963dc467bc4b9bdc1981a01a: Test that a variable declared outside a lambda can be assigned within the lambda even if the parameter name shadows the outer variable.
// 16b63ec19d7caee7c22b07523fd21b49: When Move 2 is enabled, refer to tuple fields by positional field syntax (e.g., .0, .1, ...).
