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
        let _invalid = 1 @ 2;
    }
}

//# run
script 0xCAFE::ErrorReportingTest::create_data --signers 0xBEEF --args 42u64

//# run 0xCAFE::ErrorReportingTest::parse_error_test

// Featurres:
// f3b1481edbd9e01504ad8b8972aa64b1: Show the exact token content when a parsing error occurs, enabling precise error reporting
// 63070a06dc70475ab971d589958b2c30: Save compiled Move modules and scripts to disk with proper naming conventions.
// 0ed81ed021c1455f3b7b6b2c52012423: Utilize the precedence values for parsing complex expressions correctly, especially when constructing or analyzing expression trees.
