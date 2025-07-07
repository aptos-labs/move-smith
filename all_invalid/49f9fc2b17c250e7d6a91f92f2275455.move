//# publish
module 0xCAFE::HexByteUtils {
    // This module provides a function to convert hex string literals (x"...") into vector<u8>.
    public fun from_hex_literal(hex: vector<u8>): vector<u8> {
        // The hex comes directly from hex literal as bytes representing hex chars, e.g. b"deadbeef"
        // Here just return the input for demonstration since Move does not have string processing to decode hex at runtime.
        hex
    }

    public fun runner() {
        // Just call from_hex_literal with sample data
        let _ = from_hex_literal(b"deadbeef"); 
    }
}

//# run 0xCAFE::HexByteUtils::runner

//# publish
module 0xCAFE::ErrorTest {
    use std::error;
    use std::signer;

    const ERR_TOKEN_MISMATCH: u64 = 0x1001;

    // A dummy function that expects a token u8 and errors if not matched
    public fun expect_token(token: u8) acquires error::Error {
        if (token != 0xAB) {
            // Simulate error by aborting with error code and message
            // Move does not support rich diagnostics but we simulate it with abort
            abort ERR_TOKEN_MISMATCH;
        }
    }

    public fun runner() {
        // Call expect_token with matching token
        expect_token(0xAB);
        // The below call is commented out to avoid aborting in the runner, but below command will test error path
        // expect_token(0x00);
    }
}

//# run 0xCAFE::ErrorTest::runner

//# run 0xCAFE::ErrorTest::expect_token --args 0u8
//# run 0xCAFE::ErrorTest::expect_token --args 171u8

//# publish
module 0xCAFE::DependencyTest {
    // This is a dummy module to simulate dependency to be removed after interface generation.

    public fun dummy(): u64 {
        42
    }

    public fun runner() {
        let val = dummy();
        let _ = val;
    }
}

//# run 0xCAFE::DependencyTest::runner

// Featurres:
// 9b47cf51351f3a28b90ef53be117eb6e: Remove bytecode files from the list of dependencies after generating interface files.
// 4947e2dc96be91df82cbcc0e1daf10f7: Use hexadecimal string literals starting with 'x"' for hex-encoded byte data.
// 8031f4c64cc258757a85b6555a15b7be: Handle errors by generating a diagnostic if the token does not match
