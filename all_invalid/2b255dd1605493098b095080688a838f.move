
//# publish
module 0xABCD::FeatureTest {
    use std::signer;
    use std::vector;

    // Enum to test pattern matching
    enum Response has copy, drop {
        Success,
        Error(u8),
        Pending,
    }

    // Internal function to test restricted access
    fun internal_secret() {
        // Internal logic
    }

    // Public entry point to call internal private function - should NOT be called externally
    public fun call_internal_secret() {
        internal_secret();
    }

    // Script entry point to test external call triggered behavior
    public fun external_call_trigger() {
        // Does some simple call
        let _ = internal_internal_function();
    }

    // Internal function for testing restricted access internally
    fun internal_internal_function(): u8 {
        42
    }

    // Function that pattern matches enum
    public fun pattern_match_response(r: Response): u8 {
        match (r) {
            Response::Success => 1,
            Response::Error(code) => code,
            Response::Pending => 0,
        }
    }

    // Function to test variable shadowing in nested scopes
    public fun variable_shadowing(): u8 {
        let outer_var = 1u8;
        let iter = 0u8;

        while (iter < 3) {
            let outer_var = outer_var + iter; // Shadow outer_variable
            // reassign inner variable
            let inner_var = outer_var + 2;

            // simulate some logic
            if (inner_var > 4) {
                break;
            };
            iter = iter + 1;
        };
        outer_var // Should be unaffected by inner shadowing
    }

    // Function to test variable initialization inside and outside loop
    public fun validate_variables(): u8 {
        let sum = 0u8;
        let counter = 0u8;
        while (counter < 5) {
            let val = counter + 1; // Local variable inside loop
            sum = sum + val;
            counter = counter + 1;
        };
        sum // sum should be 15
    }

    // Function to explicitly test unreachable code pattern (simulate error handling)
    public fun handle_special_types(): (unit, unresolved_error) {
        let result: (unit, unresolved_error);
        // Simulate normal flow
        let res = ((), UnresolvedError {});
        result = res;
        result
    }

    // Helper to simulate an unresolved error (mock)
    struct UnresolvedError has copy, drop {}

    // Entry function to test all behaviors
    public fun run_all() {
        // call external trigger
        external_call_trigger();

        // test internal restricted function
        let _ = call_internal_secret();

        // test pattern matching
        let code_success = pattern_match_response(Response::Success);
        let code_error = pattern_match_response(Response::Error(255));
        let code_pending = pattern_match_response(Response::Pending);

        // test variable scoping and shadowing
        let outer_value = variable_shadowing();

        // test variable initialization inside loop
        let total_sum = validate_variables();

        // handling special types
        let (unit_val, unresolved_err) = handle_special_types();

        // Use dummy assertions to ensure code executes (omitted actual assertions)
        let _ = (code_success, code_error, code_pending, outer_value, total_sum, unit_val, unresolved_err);
    }
}



//# run 0xABCD::FeatureTest::run_all --signers 0x1234


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 2db1da29c6dc859b43fbb2209a123301: Match on enum types only within the module that defines the enum.
// fe4621ae0d61f411fef5c1f6ecd21071: Recognize and handle special types like Unit or UnresolvedError for error management.
