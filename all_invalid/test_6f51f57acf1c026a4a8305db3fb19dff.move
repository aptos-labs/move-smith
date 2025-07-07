//# publish
module 0xabcde::largest_prime_factor {
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            return false
        };
        let i = 2;
        while (i <= n / 2) {
            if (n % i == 0) {
                return false
            };
            i = i + 1;
        };
        true
    }

    public fun largest_prime_factor(n: u64): u64 {
        let largest_factor = 1;
        let i = 2;
        while (i <= n / 2) {
            if (n % i == 0 && is_prime(i)) {
                largest_factor = i;
            };
            i = i + 1;
        };
        if (is_prime(n)) {
            largest_factor = n;
        };
        largest_factor
    }

    public fun test_prime_power() {
        // Test with a prime power, e.g., 64 = 2^6, should return 64 as largest prime factor
        assert!(largest_prime_factor(64) == 2, 1);
    }

    public fun test_composite_number() {
        // Test with a composite number with multiple factors, e.g., 100 = 2*2*5*5, largest prime factor should be 5
        assert!(largest_prime_factor(100) == 5, 2);
    }

    public fun test_prime_number() {
        // Test with a prime number, should return itself
        assert!(largest_prime_factor(13) == 13, 3);
    }

    public fun test_large_prime() {
        // Test with a larger prime number
        assert!(largest_prime_factor(104729) == 104729, 4);
    }

    public fun run_all_tests() {
        test_prime_power();
        test_composite_number();
        test_prime_number();
        test_large_prime();
    }
}

//# run 0xabcde::largest_prime_factor::run_all_tests --signers 0x1