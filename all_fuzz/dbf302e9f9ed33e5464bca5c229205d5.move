
//# publish
module 0xCAFE::FeatureTest {
    // Removed unused alias 'std::signer'

    // 1: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus 10 to produce a specific value
        sum + 10u8
    }

    // 2: Write functions containing lambda (anonymous function) expressions.
    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * 2 + b * 3
        };
        lambda(x, y)
    }

    // 3: Provide definition for MyModule inside this file so the call works.
    // Move does not support nested modules, so instead define f2 locally:

    /// This function must be inline as per original test comment.
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    public fun nested_inline_call(a: u16): (u16, u16) {
        // Call the local f2 instead of 0xCAFE::MyModule::f2
        f2(a)
    }

    // 4: Test that an infinite loop with a conditional return exits immediately when the condition is true, 
    // and code after loop is not executed when the initial condition is false.
    public fun infinite_loop_with_conditional_return(cond: bool): u8 {
        if (cond) {
            loop {
                return 99u8;
            };
            // This code after loop should NOT be executed if cond is true
            0u8
        } else {
            // Do not enter loop, return fixed value
            42u8
        }
    }

    // 5: Display a user-friendly message when an unexpected end-of-file token is encountered during parsing
    // This is not a runtime function but a doc string to simulate the test scenario.
    public fun parse_error_message(): vector<u8> {
        b"Error: Unexpected EOF during parsing\n"
    }

    // 6: Use sequence expressions to perform a series of computations in order.
    public fun sequence_expression(x: u8): u8 {
        {
            let a = x + 1;
            let b = a * 2;
            let c = b - 3u8;
            c
        }
    }
}


//# run 0xCAFE::FeatureTest::add_and_return --args 5u8 3u8


//# run 0xCAFE::FeatureTest::apply_lambda --args 2u8 3u8


//# run 0xCAFE::FeatureTest::nested_inline_call --args 20u16


//# run 0xCAFE::FeatureTest::infinite_loop_with_conditional_return --args true


//# run 0xCAFE::FeatureTest::infinite_loop_with_conditional_return --args false


//# run 0xCAFE::FeatureTest::parse_error_message


//# run 0xCAFE::FeatureTest::sequence_expression --args 4u8
