
//# publish
module 0xCAFE::SpecAndConstTest {
    use std::signer;

    const CONST_A: u64 = 1234;
    const CONST_B: bool = true;
    const CONST_C: address = @0xCAFE;

    spec module {
        // Spec function with no parameters returning a constant
        spec fun get_const_a(): u64 {
            CONST_A
        }

        // Spec function with parameters
        spec fun is_const_b_true(): bool {
            CONST_B
        }

        // Spec function with address constant
        spec fun get_const_c(): address {
            CONST_C
        }
    }

    public fun local_vars_unused_warning(x: u8) {
        // Declare local variables that are unused
        let _used_var = x + 1;
        let _another_unused: u8 = 42;

        // Intentionally declare an unused variable without underscore prefix to trigger warning if compiler supports
        let unused_var = 100;

        // Use a variable to avoid unused warning; we won't use unused_var on purpose
        let _use_var_again = _used_var * 2;
    }

    // A function that uses constants and spec functions (no spec block calls at runtime, only used for verification)
    public fun use_constants(s: signer): (u64, bool, address) {
        // Just return the constants
        (CONST_A, CONST_B, CONST_C)
    }
}


//# run 0xCAFE::SpecAndConstTest::local_vars_unused_warning --args 5u8


//# run 0xCAFE::SpecAndConstTest::use_constants --signers 0xBEEF


// Featurres:
// 4cf1b5b548abbd8a56f796d3111f541a: Declare local variables in functions and have the compiler warn you if they are unused
// 730c455c57b6351e68e65e099d09df09: Define spec functions inside spec blocks to be used for formal verification.
// 4f01255250bcfb3ed5186dec52413474: Define constants with type signatures in Move modules.
