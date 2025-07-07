//# publish
module 0xabcde::prime_utils {
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            return false;
        };
        let i = 2;
        while (i * i <= n) {
            if (n % i == 0) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    // Helper function to test edge cases with small numbers
    public fun test_small_numbers() {
        assert!(!is_prime(0), 0);
        assert!(!is_prime(1), 1);
        assert!(is_prime(2), 2);
        assert!(is_prime(3), 3);
        assert!(!is_prime(4), 4);
    }

    // Helper function to test larger prime and composite
    public fun test_large_numbers() {
        assert!(is_prime(7919), 7919); // prime
        assert!(!is_prime(8000), 8000); // not prime
    }

    // Helper function to test some known prime numbers
    public fun test_primes_list() {
        let primes = vector[2u64, 3, 5, 7, 11, 13, 17, 19, 23, 29];
        let i = 0;
        while (i < vector::length(&primes)) {
            let p = *vector::borrow(&primes, i);
            assert!(is_prime(p), p);
            i = i + 1;
        };
    }
}

 //# run 0xabcde::prime_utils::test_small_numbers
 //# run 0xabcde::prime_utils::test_large_numbers
 //# run 0xabcde::prime_utils::test_primes_list