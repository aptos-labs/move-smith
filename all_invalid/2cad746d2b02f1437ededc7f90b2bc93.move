
//# publish
module 0xCAFE::ErrorHandlingTest {
    use std::error;

    // Entry function with abort in the first branch
    public entry fun abort_in_first_branch(condition: bool) {
        if (condition) {
            // Trigger an abort with a specific error code
            abort 100;
        } else {
            // Do nothing
        }
    }

    // Entry function with abort inside a code block
    public entry fun abort_in_code_block(condition: bool) {
        if (condition) {
            {
                // Trigger an abort with a different error code
                abort 200;
            }
        }
    }
}


//# run 0xCAFE::ErrorHandlingTest::abort_in_first_branch --signers 0xCAFE --args true
# This should abort with error code 100


//# run 0xCAFE::ErrorHandlingTest::abort_in_first_branch --signers 0xCAFE --args false
# This should complete successfully without abort


//# run 0xCAFE::ErrorHandlingTest::abort_in_code_block --signers 0xCAFE --args true
# This should abort with error code 200


//# run 0xCAFE::ErrorHandlingTest::abort_in_code_block --signers 0xCAFE --args false
# This should complete successfully without abort

// Featurres:
// edc9d0d61de6fbc8b2234f66db223e99: Test that abort statements inside both conditional branches and code blocks correctly cause execution to abort with the expected error code.
// 1d3f5417b818a4ff0c73905c1617597a: Use the 'entry' modifier on module members to indicate entry functions.
// 5fe5f0c6c64e1761cc6a8bb2b2be8730: Support different token types (identifier, star, numeric value) after commas to continue parsing additional access specifiers.
