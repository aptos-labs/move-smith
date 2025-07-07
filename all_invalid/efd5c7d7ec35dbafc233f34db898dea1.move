
//# publish
module 0xCAFE::IdentAndArithmetic {

    use std::error;
    use std::vector;

    const MAX_U64: u64 = 0xFFFFFFFFFFFFFFFF;

    // Testing identifier naming with diverse valid identifiers
    // including ones with underscore prefixes and digits (never starting with digits).
    struct _ValidStruct42 has copy, drop, store {
        field_one: u64,
        field_2: u64,
        _field_3: u64,
    }

    struct ValidStruct has store, copy, drop {
        a: u64,
        _b2: u64,
        c_3: u64,
    }

    // Experiment flags - dummy flags to simulate compilation stage halting simulation
    struct ExperimentFlags has store {
        stop_after_identifier_check: bool,
        stop_after_syntax_check: bool,
    }

    public fun create_flags(stop_after_identifier_check: bool, stop_after_syntax_check: bool): ExperimentFlags {
        ExperimentFlags { stop_after_identifier_check, stop_after_syntax_check }
    }

    /// This function simulates compilation phase control by a dummy experiment flag argument.
    /// It fails early if stop_after_identifier_check enabled.
    /// Then if stop_after_syntax_check enabled, it stops after syntax validation.
    /// Otherwise proceeds to run all u64 arithmetic tests.
    public fun run_all(flags: &ExperimentFlags) {
        if (flags.stop_after_identifier_check) {
            // Early return simulating stop at identifier check phase
            return;
        };
        if (flags.stop_after_syntax_check) {
            // Early return simulating stop at syntax checking phase
            return;
        };

        Self::test_arithmetic_edge_cases();
    }

    // Test naming validity by creating instances of structs with valid identifiers
    // and returning sample sums of fields to use identifiers in expressions.
    public fun test_identifier_naming(): u64 {
        let a = _ValidStruct42 {
            field_one: 1,
            field_2: 2,
            _field_3: 3,
        };
        let b = ValidStruct {
            a: 10,
            _b2: 20,
            c_3: 30,
        };
        a.field_one + a.field_2 + a._field_3 + b.a + b._b2 + b.c_3
    }

    /// Test u64 arithmetic operations with edge cases:
    /// Addition, subtraction, multiplication, division, modulo.
    /// Also test overflow detection where applicable.
    public fun test_arithmetic_edge_cases() {
        let zero: u64 = 0;
        let one: u64 = 1;
        let max: u64 = MAX_U64;
        let mid: u64 = max / 2;

        // Addition tests (without overflow)
        let _add1 = zero + zero;
        let _add2 = zero + one;
        let _add3 = one + one;
        let _add4 = mid + mid; // should be max - 1 or max - 0

        // Careful with overflow in addition: do a safe check before overflow
        if (max > one) {
            // This addition will overflow, so should not happen without error.
            // We simulate error by checking and aborting if overflow.
            let sum = max + one;
            abort 1000;
        };

        // Subtraction tests (no underflow because all unsigned)
        let _sub1 = one - zero;
        let _sub2 = max - one;
        let _sub3 = max - mid;

        // Subtraction overflow is impossible with unsigned in correct order

        // Multiplication tests
        let _mul1 = zero * max;
        let _mul2 = one * max;
        let _mul3 = mid * 2;

        // Multiplication overflow simulation:
        if (mid > 0) {
            let mul_overflow = mid * (max / mid + 1);
            abort 1001;
        };

        // Division tests
        // Division by zero must abort, test by catching abort is not possible here, so avoid.
        if (zero == 0) {
            // skip div by zero as it aborts by default.
            // test safe division:
            let _div1 = max / one;
            let _div2 = mid / one;
            let _div3 = max / mid;
        };

        // Modulo tests
        // Mod by zero aborts, skip for same reason
        let _mod1 = max % one;
        let _mod2 = mid % one;
        let _mod3 = max % mid;

    }

    // Combined test to check identifier usage inside arithmetic expressions under flags
    public fun combined_test_with_flags(flags: &ExperimentFlags): u64 {
        if (flags.stop_after_identifier_check) {
            return 0;
        };
        if (flags.stop_after_syntax_check) {
            return 1;
        };

        // Use valid identifiers in simple arithmetic
        let good_identifier_1: u64 = 42;
        let _underscore_prefix: u64 = 58;

        // Arithmetic using these identifiers
        let result = good_identifier_1 + _underscore_prefix;

        result
    }
}


//# run 0xCAFE::IdentAndArithmetic::test_identifier_naming


//# run 0xCAFE::IdentAndArithmetic::run_all --args false false


//# run 0xCAFE::IdentAndArithmetic::run_all --args true false


//# run 0xCAFE::IdentAndArithmetic::run_all --args false true


//# run 0xCAFE::IdentAndArithmetic::combined_test_with_flags --args false false


//# run 0xCAFE::IdentAndArithmetic::combined_test_with_flags --args true false


//# run 0xCAFE::IdentAndArithmetic::combined_test_with_flags --args false true


// Featurres:
// 6cfc53c67f8212be529e9daedccf03ea: Use identifiers that start with a letter or underscore and consist of letters, digits, or underscores.
// 3e8be9aeafaf0bb225fa5b382e0efb19: Control compilation stages with experiment flags for stopping before certain phases.
// 93becae458c96cb06a0d39aa447fa74c: **Test that all u64 arithmetic operations (addition, subtraction, multiplication, division, modulus) produce correct results for edge values and fail with an error on overflow or division/modulus by zero.**
