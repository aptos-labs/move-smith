//# publish
module 0x1::U128ArithmeticTest {

    /// Resource to test resource acquisition
    resource struct TestResource {
        dummy: bool,
    }

    /// Function to acquire a resource
    public fun acquire_resource(account: &signer): &mut TestResource acquires TestResource {
        // Publish the resource if not existing, else borrow mutable
        if (!exists<TestResource>(signer::address_of(account))) {
            move_to(account, TestResource { dummy: true });
        }
        borrow_global_mut<TestResource>(signer::address_of(account))
    }

    /// Helper function for safe addition, returns Option
    public fun safe_add(a: u128, b: u128): option<u128> {
        if (a > u128::MAX - b) {
            // would overflow
            option::none()
        } else {
            option::some(a + b)
        }
    }

    /// Helper function for safe subtraction, returns Option
    public fun safe_sub(a: u128, b: u128): option<u128> {
        if (a < b) {
            // underflow
            option::none()
        } else {
            option::some(a - b)
        }
    }

    /// Helper function for safe multiplication, returns Option
    public fun safe_mul(a: u128, b: u128): option<u128> {
        if (a == 0 || b == 0) {
            option::some(0)
        } else if (a > u128::MAX / b) {
            // overflow
            option::none()
        } else {
            option::some(a * b)
        }
    }

    /// Helper function for safe division, returns Option
    public fun safe_div(a: u128, b: u128): option<u128> {
        if (b == 0) {
            option::none()
        } else {
            option::some(a / b)
        }
    }

    /// Helper function for safe modulus, returns Option
    public fun safe_mod(a: u128, b: u128): option<u128> {
        if (b == 0) {
            option::none()
        } else {
            option::some(a % b)
        }
    }

    /// Function performing various arithmetic operations and resource acquisition
    public fun run_test(account: &signer) {
        // Acquire resource
        let _res = acquire_resource(account);

        // Define some test values
        let a: u128 = 340282366920938463463374607431768211455; // u128::MAX
        let b: u128 = 1;

        // Test addition (should overflow for a + 1)
        let add_result = safe_add(a, b);
        // Expect None (overflow)

        // Test subtraction (a - 1)
        let sub_result = safe_sub(a, b);
        // Expect some
        assert!(option::is_some(&sub_result));

        // Test multiplication (a * 1)
        let mul_result = safe_mul(a, b);
        assert!(option::is_some(&mul_result));
        assert::assert_eq!(option::extract(mul_result), a);

        // Test multiplication overflow (a * 2)
        let mul_overflow = safe_mul(a, 2);
        assert!(option::is_none(&mul_overflow));

        // Test division (a / 1)
        let div_result = safe_div(a, b);
        assert!(option::is_some(&div_result));
        assert::assert_eq!(option::extract(div_result), a);

        // Test division by zero
        let div_zero = safe_div(a, 0);
        assert!(option::is_none(&div_zero));

        // Test modulus (a % 1)
        let mod_result = safe_mod(a, b);
        assert!(option::is_some(&mod_result));
        assert::assert_eq!(option::extract(mod_result), 0);

        // Test modulus by zero
        let mod_zero = safe_mod(a, 0);
        assert!(option::is_none(&mod_zero));
    }
}
 
//# run 0x1::U128ArithmeticTest::run_test --signers 0x1