//#publish
module 0xabc::test_u128_arithmetics {
    use std::error;

    // Function to perform addition tests
    public fun test_addition() {
        // Normal cases
        assert!(0u128 + 0u128 == 0u128, 1000);
        assert!(1u128 + 1u128 == 2u128, 1001);
        assert!(13u128 + 67u128 == 80u128, 1002);
        assert!(340282366920938463463374607431768211455u128 + 0u128 == 340282366920938463463374607431768211455u128, 1003);
        assert!(340282366920938463463374607431768211454u128 + 1u128 == 340282366920938463463374607431768211455u128, 1004);

        // Edge case: maximum value
        assert!(340282366920938463463374607431768211455u128 + 0u128 == 340282366920938463463374607431768211455u128, 1005);
    }

    // Function to perform subtraction tests
    public fun test_subtraction() {
        // Normal cases
        assert!(1u128 - 0u128 == 1u128, 2000);
        assert!(1u128 - 1u128 == 0u128, 2001);
        assert!(52u128 - 13u128 == 39u128, 2002);
        assert!(340282366920938463463374607431768211455u128 - 0u128 == 340282366920938463463374607431768211455u128, 2003);
        assert!(340282366920938463463374607431768211455u128 - 1u128 == 340282366920938463463374607431768211454u128, 2004);
    }

    // Function to perform multiplication tests
    public fun test_multiplication() {
        // Normal cases
        assert!(0u128 * 0u128 == 0u128, 3000);
        assert!(1u128 * 0u128 == 0u128, 3001);
        assert!(1u128 * 1u128 == 1u128, 3002);
        assert!(6u128 * 7u128 == 42u128, 3003);
        assert!(10u128 * 10u128 == 100u128, 3004);

        // Edge case: maximum value * 1
        assert!(340282366920938463463374607431768211455u128 * 1u128 == 340282366920938463463374607431768211455u128, 3005);

        // Edge case: maximum value * 2 (should panic or error test)
        // Using try-catch to handle compile-time overflow, simulated here
        error::catch::<(), _>(|| {
            let _res = 340282366920938463463374607431768211455u128 * 2u128;
        }, 3100);
    }

    // Function to perform division tests
    public fun test_division() {
        // Normal cases
        assert!(1u128 / 1u128 == 1u128, 4000);
        assert!(6u128 / 3u128 == 2u128, 4001);
        assert!(340282366920938463463374607431768211455u128 / 1u128 == 340282366920938463463374607431768211455u128, 4002);
        assert!(340282366920938463463374607431768211455u128 / 340282366920938463463374607431768211455u128 == 1u128, 4003);
    }

    // Function to test division by zero (should fail)
    public fun test_divide_by_zero() {
        error::catch::<(), _>(|| {
            let _res = 1u128 / 0u128;
        }, 4100);
        error::catch::<(), _>(|| {
            let _res = 340282366920938463463374607431768211455u128 / 0u128;
        }, 4101);
    }

    // Function to perform modulus tests
    public fun test_modulus() {
        // Normal cases
        assert!(1u128 % 1u128 == 0u128, 5000);
        assert!(8u128 % 3u128 == 2u128, 5001);
        assert!(340282366920938463463374607431768211455u128 % 1u128 == 0u128, 5002);
        assert!(340282366920938463463374607431768211455u128 % 340282366920938463463374607431768211455u128 == 0u128, 5003);
        assert!(340282366920938463463374607431768211454u128 % 340282366920938463463374607431768211455u128 == 340282366920938463463374607431768211454u128, 5004);
    }

    // Function to test modulus by zero (should fail)
    public fun test_modulus_by_zero() {
        error::catch::<(), _>(|| {
            let _res = 1u128 % 0u128;
        }, 5100);
        error::catch::<(), _>(|| {
            let _res = 340282366920938463463374607431768211455u128 % 0u128;
        }, 5101);
    }

    // Run all tests
    public fun run_tests() {
        test_addition();
        test_subtraction();
        test_multiplication();
        test_division();
        test_divide_by_zero();
        test_modulus();
        test_modulus_by_zero();
    }
}

//#run 0xabc::test_u128_arithmetics::run_tests