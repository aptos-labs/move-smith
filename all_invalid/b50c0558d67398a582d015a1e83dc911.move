// #! publish
module 0xCAFE::ErrorHandlingTest {
    use std::vector;

    // Function that always aborts with a custom error code
    public fun trigger_abort() {
        abort 999;
    }

    // Function that detects if an abort occurred based on status
    public fun check_error(status: u64): bool {
        status != 0
    }

    // Function to test detailed error message propagation
    public fun test_error_message() {
        let res = catch (trigger_abort());  // Added missing parentheses
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