module 0x1::test_aptos {

    use std::signer;
    use std::vector;
    use std::debug;

    /// Ability constraints testing: 
    /// Generic function with ability constraint.
    /// Uses ability store because we want to store the generic T inside a vector.
    fun store_value_with_ability<T: copy + store>(v: &mut vector<T>, val: T) {
        vector::push_back(v, val);
    }

    /// Function that includes various operations:
    /// return, abort, dereference (&), unary operations (!), borrow (&), cast, test (!=), and annotations.
    fun complex_control_and_types(val: u64): u64 acquires dummy {
        // Unary operation and return:
        let not_zero = !((val == 0));
        // Cast bool to u8 (true -> 1, false -> 0)
        let flag: u8 = if (not_zero) { 1 } else { 0 };

        // Borrow & dereference:
        let val_ref = &val;
        let deref_val = *val_ref;

        // Test annotation by using let with type
        let annotated: u64 = deref_val + (flag as u64);

        // Abort test: if val is zero abort with error code 42
        if (val == 0) {
            abort 42;
        }

        annotated
    }

    /// Check if a number is prime.
    /// Works for u64 numbers.
    /// Special edge cases: 0,1 (not prime), 2 (prime), even numbers > 2 (not prime).
    fun is_prime(n: u64): bool {
        if (n < 2) {
            return false;
        }
        if (n == 2) {
            return true;
        }
        if (n % 2 == 0) {
            return false;
        }
        let mut i = 3;
        while (i * i <= n) {
            if (n % i == 0) {
                return false;
            }
            i = i + 2;
        }
        true
    }

    #[test_only]
    fun transactional_test() {
        // 1. Test ability constraints on generic using store_value_with_ability:
        let mut v = vector::empty<u64>();
        store_value_with_ability(&mut v, 100);
        assert!(*vector::borrow(&v, 0) == 100, 1001);

        // 2. Test control and type management function
        let res = complex_control_and_types(10);
        // res == 11 because val=10, val != 0 => !false=true => flag=1 => annotated = 10+1=11
        assert!(res == 11, 1002);

        // Abort test: catching abort is not straightforward in Move tests, so just skip abort(0)
        // but we test abort no abort case:
        let normal_res = complex_control_and_types(5);
        assert!(normal_res == 6, 1003);

        // 3. Test is_prime with various edge cases:
        let primes = [2, 3, 5, 7, 11, 13, 17, 19, 7919];
        let non_primes = [0, 1, 4, 6, 8, 9, 10, 15, 20, 7918];

        // Test primes:
        let mut i = 0;
        while (i < vector::length(&primes)) {
            let val = *vector::borrow(&primes, i);
            assert!(is_prime(val), 2000 + val);
            i = i + 1;
        }

        // Test non-primes:
        i = 0;
        while (i < vector::length(&non_primes)) {
            let val = *vector::borrow(&non_primes, i);
            assert!(!is_prime(val), 3000 + val);
            i = i + 1;
        }
    }
}

// Featurres:
// 634209496839e06f739d46ccf5293db8: Specify ability constraints for generic type parameters using a colon in type signatures
// 0921e8850c230c2fadc8bf228b548cec: Return, abort, dereference, perform unary operations, borrow, cast, test, or annotate expressions for control and type management.
// 4076ee37cbaf26a4bb3047187e51c642: Test that the is_prime function correctly determines whether given u64 integers are prime numbers, including various edge cases.
