
//# publish
module 0xDEAD::ParserDiagnostics {
    // This module is intentionally left empty as the test primarily targets the
    // parsing and diagnostics at the compiler and VM level.
}


// we simulate a script that contains a syntax error involving an unexpected token.
// The following script is purposely malformed.

//# run
script {
    //! Unexpected token '***' in expression
    let x = 5 *** 10;  // Error at this line: '***' is invalid syntax
}


// we include a context with an ambiguous comparison without space, prompting a warning.
// This is just part of syntax that might trigger a suggestion in the real compiler errors.

//# run
script {
    let a = 10;
    let b = if (a<20) { 1 } else { 0 }; // Possible ambiguity: insert space before '<'
}


// we write a module with nested expressions and a filtered function that examines the AST.

//# publish
module 0xBEEF::ASTFilteringTest {
    use std::vector;

    public fun filter_example(input: vector<u8>): vector<u8> {
        // Imagine this function filters AST nodes; here we just pass through.
        input
    }

    public fun run_filter() {
        let data = vector::empty<u8>();
        vector::push_back(&mut data, 1);
        vector::push_back(&mut data, 2);
        let filtered_data = filter_example(data);
    }
}

// These are the transactional commands to run each test scenario:


//# run 0xDEAD::ParserDiagnostics::/script --args
// Expected: Diagnostic error on unexpected token '***'


//# run 0xDEAD::ParserDiagnostics::/script --args
// Expected: Warning about ambiguous '<' operator, suggesting space insertion


//# run 0xBEEF::ASTFilteringTest::run_filter --args
// No assertions; this exercises AST filtering functionality


// Featurres:
// 6d4255c438d053ad41e85f2a5e2fffae: Generate a diagnostic error message when an unexpected token is encountered during parsing
// e518d62d47a1bb813b7828b3ff3f77ed: Add a diagnostic secondary label suggesting inserting a blank space before the '<' operator when ambiguity occurs.
// 94c414d896fd044e3e113f97fb8b963e: Apply AST filtering for verification purposes.
