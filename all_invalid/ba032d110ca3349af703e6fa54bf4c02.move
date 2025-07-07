
//# publish
module 0xCAFE::TestModule {
    // A function to trigger an abort via assertion failure
    public fun trigger_abort() {
        assert(false, 42);
    }

    // A function to run code after the assert, which should not execute if assert fails
    public fun code_after_assert() {
        // This should not be executed if the assertion in trigger_abort aborts
        // Use a dummy returning value or just a no-op
        return;
    }
}


//# publish
module 0xCAFE::TypeTestModule {
    // Function that performs nested type tests and conversions
    public fun type_test_and_cast(): bool {
        let value = 10;
        // Grouped expression with parentheses, with type cast
        let cast_value = (value + 5) as u8;
        // Type test using 'is' (simulate check by comparison in Move)
        let is_u8 = (cast_value is u8);
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

// Featurres:
// d90fff8d9359a444e257b0760151f235: Test that the script correctly aborts when an assertion fails inside a conditional branch and that code after the conditional is not executed if the assertion inside the branch passes.
// fb3e5a75b2fa8991f607823b62860771: Transform modules within package definitions by applying the extract_spec_module function based on their address context.
// 40c0c783c4218f2a5f72add1dc89e09a: Group expressions with parentheses and optionally annotate the expression with a type, perform a type cast ('as'), or type test ('is').
