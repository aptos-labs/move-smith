
//# publish
module 0xBEEF::TestExpressions {
    use std::signer;
    use std::vector;

    // Helper function to deliberately cause an error (e.g. by illegal dereference)
    public fun trigger_error_condition() {
        let _ = *(vector::empty<u8>()); // invalid dereference - should produce diagnostic error
    }

    // Helper function to test unary expression with sub-expression
    public fun unary_sub_expression(x: u8): u8 {
        !x
    }

    // Helper function to test binary expression with sub-expressions
    public fun binary_sub_expressions(a: u8, b: u8): u8 {
        a + b
    }

    // Helper function to test parenthesized expressions
    public fun parenthesized_expression(x: u8): u8 {
        (x * 2) + 1
    }

    // Helper function to generate an internal error via invalid code (simulate diagnostic)
    public fun report_diagnostic() {
        // intentionally cause an error: use uninitialized variable (simulate error)
        // The Move compiler should catch this as an error
        let _uninit: u8;
        let _ = _uninit; // use of uninitialized variable: should trigger diagnostic
    }

    // Helper function to test nested dereference (valid case)
    public fun nested_dereference(vec: vector<u8>): u8 {
        let ref = borrow_global<(vector<u8>)>(0xCAFE); // invalid; just for syntax
    }

    // Run functions in script to verify expressions
    public fun run_expression_tests() {
        let _ = unary_sub_expression(5);
        let _ = binary_sub_expressions(3, 4);
        let _ = parenthesized_expression(7);
        // trigger error on purpose
        trigger_error_condition();
        // report diagnostic with invalid code
        report_diagnostic();
    }
}


//# run 0xBEEF::TestExpressions::run_expression_tests


// Featurres:
// ebcf022d04dccb8e77d3b9c553d722b4: Create dereference or unary expressions with sub-expressions.
// df481cc962cb6002eb2360c53f0fa1a7: In script modules, do not use lambda-lifted functions, as lambda lifting is disallowed in scripts.
// d0b1590093892fcbd530e24213ca133e: Handle diagnostic errors with a custom error reporting mechanism
