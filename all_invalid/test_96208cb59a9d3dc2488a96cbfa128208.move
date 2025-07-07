//# publish
module 0x1::number_utils {
    /// Checks if given number n is prime
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            return false;
        };

        let mut i = 2;
        while (i <= n / 2) {
            if (n % i == 0) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    /// Checks if the number is divisible by 3
    public fun is_divisible_by_3(n: u64): bool acquires 0x0 {
        n % 3 == 0
    }

    /// Runs multiple prime checks to verify combined logic
    public fun combined_test() {
        assert!(!is_prime(1), 1);
        assert!(is_prime(2), 2);
        // Verify that 9 is divisible by 3, but not prime
        assert!(is_divisible_by_3(9), 9);
        assert!(!is_prime(9), 9);
        // Check a larger prime, 23
        assert!(is_prime(23), 23);
        // Check non-prime multiple of 4
        assert!(!is_prime(20), 20);
    }
}

//# run 0x1::number_utils::combined_test
