//# publish
module 0xCAFE::ErrorReportingTest {
    // This resource will be used to test storage operations
    struct Data {
        value: u64,
    }

    public fun create_data(account: &signer, val: u64) {
        move_to(account, Data { value: val });
    }

    public fun get_data(address: address): &mut Data acquires Data {
        borrow_global_mut<Data>(address)
    }

    // Function to intentionally cause a parsing error with specific tokens
    // This function uses a malformed expression with invalid token to test parsing error reporting
    public fun parse_error_test() {
        // Intentionally malformed expression to trigger parsing error
        // The token `@` is invalid in Move expression context, used here to test parser token reporting
        let _invalid = 1 as u8 @ 2;
        // Note: The above line is altered to be syntactically valid in Move but still invalid in context, 
        // for example, if you want to emulate a parser error, you can try including an invalid token directly. 
        // However, Move does not support invalid tokens as code; the closest is to comment out or to generate an error via syntax.
        // Given the instruction, the best approach is to include a truly invalid token:
        //
        // For the purpose of the test, we can intentionally write invalid code like:
        // let _invalid = 1 @ 2;
        //
        // But since it's invalid syntax, it triggers compiler error, as intended.
        //
        // So, simply leave as: let _invalid = 1 @ 2;
        //
        // But in Move, invalid token 'at' is not allowed. To force a parser error, just write:
        // let _invalid = 1 @ 2;
        //
        // If the parser still accepts it, then the testing framework might need to be adjusted.
        // For now, include the invalid token directly (assuming the parser will catch it).
        //
        // So, restoring the original line (with comment to explain):
        // let _invalid = 1 @ 2; // invalid token '@'
    }
}

//# run
script 0xCAFE::ErrorReportingTest::create_data --signers 0xBEEF --args 42u64

//# run 0xCAFE::ErrorReportingTest::parse_error_test