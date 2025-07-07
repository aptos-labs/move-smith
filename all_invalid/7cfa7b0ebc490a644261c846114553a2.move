
//# publish
module 0xCAFE::BacktraceTest {
    use std::debug;
    use std::signer;

    /// Trigger an abort with optional backtrace based on environment setting
    public fun trigger_abort_with_backtrace(flag: bool) {
        if (flag) {
            debug::abort_with_code(1234);
        } else {
            debug::abort_with_code(5678);
        };
    }

    public fun test_parameters(a: u64, b: bool, c: u8): u64 {
        let sum = 0u64;
        if (b) {
            sum = sum + a;
        } else {
            sum = sum + (c as u64);
        };
        sum
    }
}


//# run 0xCAFE::BacktraceTest::trigger_abort_with_backtrace -- args true

//# run 0xCAFE::BacktraceTest::trigger_abort_with_backtrace -- args false


//# run 0xCAFE::BacktraceTest::test_parameters -- args 123u64 true 10u8


//# publish
module 0xCAFE::U128ArithmeticTest {
    use std::math;
    use std::signer;

    public fun add_u128(a: u128, b: u128): u128 {
        a + b
    }

    public fun sub_u128(a: u128, b: u128): u128 {
        a - b
    }

    public fun mul_u128(a: u128, b: u128): u128 {
        a * b
    }

    public fun div_u128(a: u128, b: u128): u128 {
        assert!(b != 0, 1);
        a / b
    }

    public fun mod_u128(a: u128, b: u128): u128 {
        assert!(b != 0, 2);
        a % b
    }

    /// Test edge cases for arithmetic ops
    public fun edge_tests() {
        let max = 0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffffu128;
        let one = 1u128;

        // max + 0 should be max
        let _ = add_u128(max, 0u128);

        // max + 1 should overflow and abort, but testing by normal call that should cause abort
        // This is intended to abort for verification.
        let _ = add_u128(max, one);

        // max - max = 0
        let _ = sub_u128(max, max);

        // 0 - 1 should abort
        let _ = sub_u128(0u128, one);

        // max * 1 = max
        let _ = mul_u128(max, one);

        // max / 1 = max
        let _ = div_u128(max, one);

        // max / 0 abort
        let _ = div_u128(max, 0u128);

        // max % 1 = 0
        let _ = mod_u128(max, one);

        // max % 0 abort
        let _ = mod_u128(max, 0u128);
    }
}


//# run 0xCAFE::U128ArithmeticTest::add_u128 -- args 15u128 27u128


//# run 0xCAFE::U128ArithmeticTest::sub_u128 -- args 100u128 99u128


//# run 0xCAFE::U128ArithmeticTest::mul_u128 -- args 10u128 20u128


//# run 0xCAFE::U128ArithmeticTest::div_u128 -- args 100u128 5u128


//# run 0xCAFE::U128ArithmeticTest::mod_u128 -- args 101u128 5u128


//# run 0xCAFE::U128ArithmeticTest::edge_tests


// Featurres:
// f12bf54d2119e7acf952aa36bea8583d: Include Optional Backtrace Information Based on Environment Settings
// f87340876e763f546397e4383bbba570: Write functions with parameters that are used by the function logic.
// 073f9fa50702d32afd0553da145c72b6: Test the correct handling of 128-bit unsigned integer arithmetic operations, including addition, subtraction, multiplication, division, and modulus, ensuring proper behavior for normal cases, edge cases, and invalid/overflow scenarios that should cause failures.
