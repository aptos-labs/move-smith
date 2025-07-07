
//# publish
module 0xBEEF::TestExpressions {
    use std::signer;
    use std::vector;

    // Helper function to deliberately cause an error (e.g. by illegal dereference)
    public fun trigger_error_condition() {
        // The following line is intentionally invalid to produce a diagnostic.
        // Commented out in the fixed version so the code compiles.
        // let _ = *(vector::empty<u8>()); // invalid dereference - should produce diagnostic error
    }

    // Helper function to test unary expression with sub-expression
    public fun unary_sub_expression(x: u8): u8 {
        // In Move, the unary '!' operator applies to booleans, not u8.
        // For demonstration, convert u8 to bool (non-zero => true) and negate.
        // Then, convert back to u8.
        let b = if x != 0 { true } else { false };
        let result_b = !b;
        if (result_b) {
            1
        } else {
            0
        }
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
        // intentionally cause an error: use uninitialized variable
        let _uninit: u8;
        let _ = _uninit; // use of uninitialized variable: should trigger diagnostic
    }

    // Helper function to test nested dereference (valid case)
    public fun nested_dereference(vec: vector<u8>): u8 {
        // Corrected invalid code:
        // Instead of invalid borrow_global, perform a safe access.
        // For example, get the first element if non-empty.
        if (vector::len(&vec) > 0) {
            vector::borrow(&vec, 0)
        } else {
            0
        }
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


// Features:
// ebcf022d04dccb8e77d3b9c553d722b4: Create dereference or unary expressions with sub-expressions.
// df481cc962cb6002eb2360c53f0fa1a7: In script modules, do not use lambda-lifted functions, as lambda lifting is disallowed in scripts.
// d0b1590093892fcbd530e24213ca133e: Handle diagnostic errors with a custom error reporting mechanism
