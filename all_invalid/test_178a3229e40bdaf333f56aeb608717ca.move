//# publish
module 0x1::U128ArithmeticTests {
    use std::assert;
    
    // Helper to test that overflow panics in addition
    public fun test_add_overflow() {
        // This should panic at runtime due to overflow
        340282366920938463463374607431768211455u128 + 1u128;
    }

    // Helper to test that underflow panics in subtraction
    public fun test_sub_underflow() {
        // This should panic at runtime due to underflow
        0u128 - 1u128;
    }

    // Helper to test multiplication overflow
    public fun test_mul_overflow() {
        // This should panic due to overflow
        340282366920938463463374607431768211455u128 * 2u128;
    }

    // Helper to test division by zero
    public fun test_divide_by_zero() {
        // This should panic at runtime
        123u128 / 0u128;
    }

    // Helper to test modulus by zero
    public fun test_mod_zero() {
        // This should panic at runtime
        456u128 % 0u128;
    }

    // Runner function to compile tests
    public fun run_all_tests() {
        // These are expected to panic; calling them would cause test failures if not handled
        // For demonstration, callers can invoke individually
    }
}

//# run
script {
fun main() {
    // Normal operations
    assert!(0u128 + 0u128 == 0u128, 1000);
    assert!(1u128 + 1u128 == 2u128, 1001);
    assert!(13u128 + 67u128 == 80u128, 1100);
    assert!(100u128 + 10u128 == 110u128, 1101);

    assert!(340282366920938463463374607431768211455u128 + 0u128 == 340282366920938463463374607431768211455u128, 1200);
    assert!(1u128 + 340282366920938463463374607431768211454u128 == 340282366920938463463374607431768211455u128, 1201);
    assert!(5u128 + 340282366920938463463374607431768211450u128 == 340282366920938463463374607431768211455u128, 1202);
}
}

//# run
script {
fun main() {
    // Overflow addition should panic
    0x1::U128ArithmeticTests::test_add_overflow();
}
}

//# run
script {
fun main() {
    // Underflow subtraction should panic
    0x1::U128ArithmeticTests::test_sub_underflow();
}
}

//# run
script {
fun main() {
    // Overflow multiplication should panic
    0x1::U128ArithmeticTests::test_mul_overflow();
}
}

//# run
script {
fun main() {
    // Division by zero should panic
    0x1::U128ArithmeticTests::test_divide_by_zero();
}
}

//# run
script {
fun main() {
    // Modulus by zero should panic
    0x1::U128ArithmeticTests::test_mod_zero();
}
}