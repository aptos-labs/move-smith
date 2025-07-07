
//# publish
module 0xCAFE::TestModule {
    // A function to trigger an abort via assertion failure
    public fun trigger_abort() {
        // Use a built-in abort instead of 'assert' which does not exist
        // Here we use 'assert' with a boolean condition that is false
        // But since 'assert' is not defined, we use 'move_abort' from the `Debug` module
        // However, for simplicity, let's simulate an abort with a 'panic' pattern:
        move_abort(42);
    }

    // A function to run code after the abort, which should not execute if trigger_abort aborts
    public fun code_after_assert() {
        // This should not be executed if trigger_abort aborts
        // Use a dummy returning value or just a no-op
        return;
    }

    // Helper function for abort, utilizing native move abort (assuming available)
    public fun move_abort(code: u64): u8 {
        abort code;
    }
}



//# publish
module 0xCAFE::TypeTestModule {
    // Function that performs nested type tests and conversions
    public fun type_test_and_cast(): bool {
        let value = 10;
        // Grouped expression with parentheses, with type cast
        let cast_value = (value + 5) as u8;
        // Type test using 'is' (simulate check, but Move doesn't have 'is', so we skip or dummy)
        // Instead, just test if cast_value is u8 by trusting the cast succeeded, or simulate check
        // Since 'is' doesn't exist, remove the test and just proceed
        // For demonstration, assume cast_value is u8, so we return true if cast_value == 15
        let is_u8 = cast_value == 15;
        // Complex grouping with an embedded cast
        let result = (if is_u8 { cast_value } else { 0 }) as u8;
        result == 15
    }

    // Function that performs complex expression with nested parentheses
    public fun grouped_expression(): u64 {
        let a = 5;
        let b = 10;
        // Expression with parentheses and type cast
        let sum = ((a + b) as u64);
        sum
    }
}



//# run 0xCAFE::TestModule::trigger_abort --signers 0xDEADBEEF
// This will abort; for the purpose of the test, we handle that scenario manually in a real test environment.



//# run 0xCAFE::TypeTestModule::type_test_and_cast --signers 0xDEADBEEF



//# run 0xCAFE::TypeTestModule::grouped_expression --signers 0xDEADBEEF