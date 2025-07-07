// Transactional test for Move compiler & VM features.

//
// 1. Use this function to generate an error message when an unexpected token is encountered during parsing.
//    We'll define a utility module with a function that triggers an abort with a custom error message for unexpected tokens.
//

//# publish
module 0x1::error_utils {
    public fun unexpected_token_error(): u64 {
        // 1001: error code for unexpected token
        abort 1001;
        0
    }

    // runner for calling from test
    public fun runner() {
        Self::unexpected_token_error();
    }
}
//# run 0x1::error_utils::runner --signers 0x1

//
// 2. Use verify_script to automatically verify scripts for correctness before deployment.
//    We'll use the standard std::transaction_context::verify_script in a script before proceeding.
//

use std::transaction_context;

//# run
script {
    fun main(account: &signer) {
        transaction_context::verify_script();
    }
}

//
// 3. Exclude inline functions from bytecode generation.
//    We'll define inline funs, check that its bytecode is not present after publish.
//    Create a module with several inline functions and a runner for testing.
//

//# publish
module 0x2::inline_test {
    #[inline(always)]
    fun add_inline(a: u64, b: u64): u64 {
        a + b
    }

    #[inline(never)]
    fun add_normal(a: u64, b: u64): u64 {
        a + b
    }

    // runner that calls both, so Move compiler has to inline `add_inline`
    public fun runner(): u64 {
        let x = Self::add_inline(7, 2);
        let y = Self::add_normal(3, 4);
        x + y
    }
}
//# run 0x2::inline_test::runner --signers 0x2
