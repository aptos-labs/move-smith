//# publish
module 0xabcde::early_return_test {
    //# run
    fun main() {
        let should_return = true;
        let result_value;

        if (should_return) {
            return ();
        } else {
            result_value = 999;
        };

        // This assertion should never be reached if should_return is true
        assert!(result_value == 999, 42);
    }
}

//# run 0xabcde::early_return_test::main

//# publish
module 0xfedba::prime_check {
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            return false;
        }

        let i = 2;
        while (i <= n / 2) {
            if (n % i == 0) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    public fun test_various_primes() {
        assert!(is_prime(17), 0);
        assert!(!is_prime(20), 1);
        assert!(is_prime(23), 2);
        assert!(!is_prime(24), 3);
        assert!(is_prime(29), 4);
        assert!(!is_prime(30), 5);
        assert!(is_prime(97), 6);
        assert!(!is_prime(100), 7);
    }
}

//# run 0xfedba::prime_check::test_various_primes

//# publish
module 0xdeadbeef::sequence_copy {
    struct DataHolder has copy, drop {
        x1: u64,
        x2: u64,
        x3: u64,
        x4: u64,
        x5: u64,
    }

    fun copy_sequence(input: DataHolder): DataHolder {
        let a = input;
        let b = a;
        let c = b;
        let d = c;
        let e = d;
        e
    }

    public fun main() {
        let original = DataHolder {x1: 10, x2: 20, x3: 30, x4: 40, x5: 50};
        let copied = copy_sequence(original);
        assert!(copied.x1 == 10 && copied.x2 == 20 && copied.x3 == 30 && copied.x4 == 40 && copied.x5 == 50, 0);
    }
}

//# run 0xdeadbeef::sequence_copy::main