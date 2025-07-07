//# publish
module 0xABCDE::arithmetic_edge_cases {
    use std::assert;
    use std::error;

    /// Function to test compound arithmetic operations and boundary conditions
    public fun test_composite_operations() {
        // Test addition overflow detection
        // Note: Move panics on overflow in debug mode; for testing, we proceed assuming success or wrapping
        // We can test wrapping behavior with unchecked addition if needed (not shown here)

        // Normal addition
        assert!(100u64 + 200u64 == 300u64, 100);
        // Boundary addition
        assert!(18446744073709551615u64 + 0u64 == 18446744073709551615u64, 101);
        // Subtraction leading to zero
        assert!(50u64 - 50u64 == 0u64, 102);
        // Multiplication boundary
        assert!(2u64 * 9223372036854775807u64 == 18446744073709551614u64, 103);
        // Division normal
        assert!(1000u64 / 10u64 == 100u64, 104);
        // Modulo normal
        assert!(100u64 % 3u64 == 1u64, 105);
    }

    /// Function to intentionally cause division by zero to test failure
    public fun test_division_by_zero() {
        // Should panic or cause runtime error
        1u64 / 0u64;
    }

    /// Function to intentionally cause modulo by zero to test failure
    public fun test_modulo_by_zero() {
        // Should panic or cause runtime error
        1u64 % 0u64;
    }

    /// Function to test large multiplication overflow
    public fun test_large_multiplication_overflow() {
        // Multiplying large numbers should cause overflow
        18446744073709551615u64 * 2u64;
    }
}

 //# run 0xABCDE::arithmetic_edge_cases::test_composite_operations
 //# run 0xABCDE::arithmetic_edge_cases::test_division_by_zero
 //# run 0xABCDE::arithmetic_edge_cases::test_modulo_by_zero
 //# run 0xABCDE::arithmetic_edge_cases::test_large_multiplication_overflow


//# publish
module 0xFEE1::sum_divisible {
    public fun sum_multiples_3_or_5(limit: u64): u64 {
        let sum = 0;
        let i = 0;
        while (i < limit) {
            if (i % 3 == 0 || i % 5 == 0) {
                sum = sum + i;
            };
            i = i + 1;
        };
        sum
    }

    public fun verify_sums() {
        assert!(sum_multiples_3_or_5(10) == 23, 0);
        assert!(sum_multiples_3_or_5(1000) == 233168, 1);
    }

    public fun generate_and_verify() {
        verify_sums();
    }
}

//# run 0xFEE1::sum_divisible::generate_and_verify

//# publish
module 0x12345::variable_assignments {
    public fun test_variable_assignments() {
        let result: u64;
        if (true) {
            result = 42;
        } else {
            result = 100;
        };
        // Should be 42
        result
    }
}

//# run 0x12345::variable_assignments::test_variable_assignments

//# publish
module 0xXYZ::variable_mutability {
    public fun test_conditional_assignment() {
        let mut x: u64;
        if (true) {
            x = 7;
        } else {
            x = 14;
        };
        // Should be 7
        x
    }
}

//# run 0xXYZ::variable_mutability::test_conditional_assignment