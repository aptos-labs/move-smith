// Note: To run this test, set the environment variable before running the Move CLI or test runner:
// MVC_BACKTRACE_ENV_VAR=1 (or export MVC_BACKTRACE_ENV_VAR=1)

//# publish
module 0xA::U8Arithmetic {
    use std::debug;
    use std::signer;
    // Parameterized attributes with nested lists
    /// #[my_attribute(enabled = true, meta = [1u8, 2u8, [3u8, 4u8]])]
    struct Dummy has copy, drop {}

    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun sub_u8(a: u8, b: u8): u8 {
        a - b
    }

    public fun mul_u8(a: u8, b: u8): u8 {
        a * b
    }

    public fun div_u8(a: u8, b: u8): u8 {
        a / b
    }

    public fun mod_u8(a: u8, b: u8): u8 {
        a % b
    }

    // "Runner" that exercises valid and edge case u8 arithmetic.
    // This will trap on error cases such as overflow, underflow, or div/mod by zero
    public entry fun run_arithmetic_all(s: &signer) {
        debug::print<u8>(&add_u8(3, 4));    //7
        debug::print<u8>(&add_u8(250, 5));  //overflow (should abort)
        debug::print<u8>(&sub_u8(10, 5));   //5
        debug::print<u8>(&sub_u8(4, 6));    //underflow (should abort)
        debug::print<u8>(&mul_u8(7, 8));    //56
        debug::print<u8>(&mul_u8(50, 6));   //300, overflow (should abort)
        debug::print<u8>(&div_u8(20, 4));   //5
        debug::print<u8>(&div_u8(8, 0));    //div by zero (should abort)
        debug::print<u8>(&mod_u8(17, 5));   //2
        debug::print<u8>(&mod_u8(12, 0));   //modulo by zero (should abort)
    }
}

//# run 0xA::U8Arithmetic::run_arithmetic_all --signers 0xA

//# run 0xA::U8Arithmetic::add_u8 --signers 0xA --args 8u8 9u8
//# run 0xA::U8Arithmetic::sub_u8 --signers 0xA --args 42u8 17u8
//# run 0xA::U8Arithmetic::mul_u8 --signers 0xA --args 11u8 4u8
//# run 0xA::U8Arithmetic::div_u8 --signers 0xA --args 100u8 10u8
//# run 0xA::U8Arithmetic::mod_u8 --signers 0xA --args 23u8 7u8

// The following, when uncommented or explicitly run, should trap due to overflow, underflow, or division by zero,
// testing the Move VM's error handling and (with MVC_BACKTRACE_ENV_VAR) that a backtrace is included.

//# run 0xA::U8Arithmetic::add_u8 --signers 0xA --args 254u8 3u8    // Should error: overflow
//# run 0xA::U8Arithmetic::sub_u8 --signers 0xA --args 1u8 2u8      // Should error: underflow
//# run 0xA::U8Arithmetic::div_u8 --signers 0xA --args 8u8 0u8      // Should error: division by zero
//# run 0xA::U8Arithmetic::mod_u8 --signers 0xA --args 9u8 0u8      // Should error: mod by zero

//# run 0xA::U8Arithmetic::mul_u8 --signers 0xA --args 128u8 3u8    // Should error: overflow

//# run
script {
    use 0xA::U8Arithmetic;
    fun main() {
        let _ = U8Arithmetic::add_u8(100, 156); // Should overflow, will trap with backtrace
    }
}

//# run
script {
    use 0xA::U8Arithmetic;
    fun main() {
        // Use an attribute with nested parameter list just as a no-op usage.
        /// #[outer(name = "test", tags = [@0xA::U8Arithmetic::Dummy, 123, ["nested", true]])]
        let _x = 123u8;
    }
}