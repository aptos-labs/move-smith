//# publish
module 0xabc::u256_arithmetic_tests {

    // Helper function to check for overflow in addition
    public fun check_add_overflow(a: u256, b: u256): bool {
        a + b
    }

    // Helper function to check for overflow in multiplication
    public fun check_mul_overflow(a: u256, b: u256): bool {
        a * b
    }

    // Helper function to verify safe subtraction
    public fun check_sub(a: u256, b: u256): bool {
        a - b
    }

    // Helper function to verify safe division
    public fun check_div(a: u256, b: u256): bool {
        a / b
    }

    // Helper function to verify safe modulus
    public fun check_mod(a: u256, b: u256): bool {
        a % b
    }

    // Runner for addition boundary cases, including overflow check
    public fun run_addition_tests() {
        let max_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

        // Adding zero
        assert!(check_add_overflow(0u256, 0u256) == 0u256, 100);
        assert!(check_add_overflow(0u256, 1u256) == 1u256, 101);
        // Adding small numbers
        assert!(check_add_overflow(13u256, 67u256) == 80u256, 102);
        // Adding to max should overflow (simulate overflow check)
        // The following should fail or revert logically in actual execution
        // but here we test the expected result
        assert!(check_add_overflow(1u256, max_u256 - 1u256) == max_u256, 103);
        // Adding max and zero
        assert!(check_add_overflow(max_u256, 0u256) == max_u256, 104);
    }

    // Runner for subtraction boundary cases
    public fun run_subtraction_tests() {
        let max_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

        // Subtract zero
        assert!(check_sub(0u256, 0u256) == 0u256, 200);
        assert!(check_sub(1u256, 0u256) == 1u256, 201);
        // Subtract small from large
        assert!(check_sub(max_u256, 1u256) == max_u256 - 1u256, 202);
        // Subtract max from itself
        assert!(check_sub(max_u256, max_u256) == 0u256, 203);
        // Subtract small from max
        assert!(check_sub(max_u256, 10u256) == max_u256 - 10u256, 204);
    }

    // Runner for multiplication boundary cases
    public fun run_multiplication_tests() {
        // Small multiplications
        assert!(check_mul_overflow(0u256, 10u256) == 0u256, 300);
        assert!(check_mul_overflow(1u256, 10u256) == 10u256, 301);
        assert!(check_mul_overflow(6u256, 7u256) == 42u256, 302);
        // Max * 1 should be max
        let max_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        assert!(check_mul_overflow(max_u256, 1u256) == max_u256, 303);
        // Max * 2 should overflow in real scenario, here just simulate
        // So we test that it produces a correct product if no overflow
        // (conceptually test for overflow detection)
        // But in code, we just do the multiplication
        assert!(check_mul_overflow(max_u256, 2u256) == max_u256 * 2u256, 304);
    }

    // Runner for division boundary cases
    public fun run_division_tests() {
        let max_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        // Divide by 1
        assert!(check_div(0u256, 1u256) == 0u256, 400);
        assert!(check_div(1u256, 1u256) == 1u256, 401);
        // Divide large number by small
        assert!(check_div(max_u256, 12345678912345123456789u256) == max_u256 / 12345678912345123456789u256, 402);
        // Divide max by max
        assert!(check_div(max_u256, max_u256) == 1u256, 403);
        // Divide max by 2
        assert!(check_div(max_u256, 2u256) == max_u256 / 2u256, 404);
        // Divide by zero should fail (simulate)
        // In test, just note that actual execution should revert or error.
    }

    // Runner for modulus boundary cases
    public fun run_modulus_tests() {
        let max_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

        // Modulo by 1 always 0
        assert!(check_mod(0u256, 1u256) == 0u256, 500);
        assert!(check_mod(123u256, 1u256) == 0u256, 501);
        // Modulo max by small number
        assert!(check_mod(max_u256, 2u256) == 0u256, 502);
        // Modulo max by max should be 0
        assert!(check_mod(max_u256, max_u256) == 0u256, 503);
        // Modulo max-1 by max
        assert!(check_mod(max_u256 - 1u256, max_u256) == max_u256 - 1u256, 504);
        // Modulo by zero should fail
    }

    public fun run_tests() {
        run_addition_tests();
        run_subtraction_tests();
        run_multiplication_tests();
        run_division_tests();
        run_modulus_tests();
    }
}

#[test_only]
public fun main() {
    0xabc::u256_arithmetic_tests::run_tests();
}
