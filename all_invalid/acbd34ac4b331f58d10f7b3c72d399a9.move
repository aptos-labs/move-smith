//# publish
module 0x1::test_module {
    use std::error;

    // Inline non-native function with body
    fun inline_sum(x: u64, y: u64): u64 {
        x + y
    }

    // Function to test boundary cases of addition
    fun test_addition_overflow(): bool {
        let max = 18446744073709551615; // u64::MAX
        // Attempting to add 1 should overflow
        // This will cause an abort in Move since overflow checking is enabled by default
        let result = error::abort_code_if(
            (max + 1) == 0,
            error::INVALID_DATA
        );
        // Should abort before reaching here
        true
    }

    // Function to test subtraction with underflow
    fun test_subtraction_underflow(): bool {
        let zero = 0;
        // Subtracting 1 from zero should underflow and abort
        error::abort_code_if(
            (0 - 1) == 0,
            error::INVALID_DATA
        );
        true
    }

    // Function to test multiplication overflow
    fun test_multiplication_overflow(): bool {
        let max = 18446744073709551615; // u64::MAX
        error::abort_code_if(
            (max * 2) == 0,
            error::INVALID_DATA
        );
        true
    }

    // Function to test division by zero
    fun test_division_by_zero(): bool {
        let x = 123;
        // Dividing by zero should cause abort
        error::abort_code_if(
            (x / 0) == 0,
            error::INVALID_DATA
        );
        true
    }

    // Function to test modulo by zero
    fun test_modulo_zero(): bool {
        let x = 123;
        // Modulo by zero should cause abort
        error::abort_code_if(
            (x % 0) == 0,
            error::INVALID_DATA
        );
        true
    }

    // Function to perform all arithmetic tests
    public fun run_arithmetic_tests(): bool {
        // Normal addition
        assert!(inline_sum(10, 20) == 30);
        // Boundary addition (should overflow and abort, so call separately)
        // For testing, we demonstrate the call instead of asserting

        // Normal subtraction
        assert!(5 - 3 == 2);

        // Normal multiplication
        assert!(3 * 4 == 12);

        // Division
        assert!(10 / 2 == 5);

        // Modulo
        assert!(10 % 3 == 1);

        // Call boundary tests (these will abort if run)
        // Uncomment to test individually
        // self::test_addition_overflow();
        // self::test_subtraction_underflow();
        // self::test_multiplication_overflow();
        // self::test_division_by_zero();
        // self::test_modulo_zero();

        true
    }
}

// Spec block with 'pragma friend' directives
//@[pragma friend]
spec module 0x1::test_module {
    // Declare friend modules, for example
    friends: [0x2::friend_module, 0x3::another_module]
}

//# run 0x1::test_module::run_arithmetic_tests