
//# publish
module 0xCAFE::ErrorHandlingTest {
    // Removed the unused import
    // use std::error;

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


//# run 0xCAFE::ErrorHandlingTest::abort_in_first_branch --signers 0xCAFE --args false


//# run 0xCAFE::ErrorHandlingTest::abort_in_code_block --signers 0xCAFE --args true


//# run 0xCAFE::ErrorHandlingTest::abort_in_code_block --signers 0xCAFE --args false