//# publish
module 0xabcde::prime_utils {
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            return false;
        };
        let i = 2;
        while (i <= n / 2) {
            if (n % i == 0) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    public fun find_smallest_prime_above(limit: u64): u64 {
        let mut candidate = limit + 1;
        while (!is_prime(candidate)) {
            candidate = candidate + 1;
        };
        candidate
    }

    public fun test_prime_detection() {
        assert!(!is_prime(0), 0);
        assert!(!is_prime(1), 1);
        assert!(is_prime(2), 2);
        assert!(is_prime(3), 3);
        assert!(!is_prime(4), 4);
        assert!(is_prime(5), 5);
        assert!(!is_prime(6), 6);
        assert!(is_prime(7), 7);
        assert!(!is_prime(8), 8);
        assert!(!is_prime(9), 9);
        assert!(!is_prime(10), 10);
        assert!(is_prime(11), 11);
        assert!(!is_prime(12), 12);
        assert!(is_prime(13), 13);
    }

    public fun test_find_smallest_prime_above() {
        assert_eq!(find_smallest_prime_above(0), 2);
        assert_eq!(find_smallest_prime_above(14), 17);
        assert_eq!(find_smallest_prime_above(100), 101);
        assert_eq!(find_smallest_prime_above(17), 19);
    }
}

//# run 0xabcde::prime_utils::test_prime_detection
//# run 0xabcde::prime_utils::test_find_smallest_prime_above