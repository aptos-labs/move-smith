//# publish
module 0x1234::addition {
    public fun add_and_return_value(a: u8, b: u8): u8 {
        {a + b} + {return 42; 0}
    }

    public fun run_add_and_return_value() {
        // No args needed; just call the function
        add_and_return_value(10, 20);
    }
}

//# run 0x1234::addition::run_add_and_return_value

//# publish
module 0x5678::shifting {
    public fun test_bitwise_shifts(): bool {
        // Boundary checks for u8
        let max_shift = 8;
        // Shifting by more than bit size should fail (but in test, we just check behavior)
        // The test is to assert proper handling of shifts, so we assume shifts > bits are invalid
        // so, no explicit assert, just testing expected behavior with safe shift counts.
        {assert!(0u8 << 0u8 == 0u8, 1000);}
        {assert!(0u8 >> 0u8 == 0u8, 1001);}
        {assert!(255u8 << 7u8 == 128u8, 1002);}
        {assert!(255u8 >> 7u8 == 1u8, 1003);}
        // Shifting by >= bits should be invalid; in real code, it would fail, but here we just test shifts by 8 (which wraps/truncates) to see behavior.
        {assert!(0u8 << 8u8 == 0u8, 1004);}
        {assert!(255u8 >> 8u8 == 0u8, 1005);}
        true
    }
}

//# run 0x5678::shifting::test_bitwise_shifts

//# publish
module 0x9abc::prime_checker {
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

    public fun test_primality() {
        // Test small primes and non-primes
        assert!(!is_prime(0), 0);
        assert!(!is_prime(1), 1);
        assert!(is_prime(2), 2);
        assert!(is_prime(3), 3);
        assert!(!is_prime(4), 4);
        assert!(is_prime(13), 13);
        assert!(!is_prime(20), 20);
        assert!(is_prime(17), 17);
        assert!(!is_prime(49), 49);
        assert!(is_prime(23), 23);
    }
}

//# run 0x9abc::prime_checker::test_primality