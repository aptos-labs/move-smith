
//# publish
module 0xCAFE::PrimeChecker {
    use std::vector;

    /// Check if a given u64 number is prime.
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            false
        } else if (n == 2) {
            true
        } else if (n % 2 == 0) {
            false
        } else {
            let i = 3;
            let is_prime_flag = true;
            while (i * i <= n && is_prime_flag) {
                if (n % i == 0) {
                    is_prime_flag = false;
                };
                i = i + 2;
            };
            is_prime_flag
        }
    }

    /// A generic struct with an optional type parameter that is a primitive type
    struct PrimeStatus<T: copy + drop> has copy, drop {
        number: u64,
        is_prime: bool,
        marker: T,
    }

    /// Create a PrimeStatus<u8> for number 7
    public fun example_status(): PrimeStatus<u8> {
        let number = 7u64;
        let result = is_prime(number);
        PrimeStatus<u8> {
            number,
            is_prime: result,
            marker: 0u8,
        }
    }

    /// Create a vector of prime status for an array of numbers.
    public fun check_primes(numbers: vector<u64>): vector<PrimeStatus<bool>> {
        let results = vector::empty<PrimeStatus<bool>>();
        let length = vector::length(&numbers);
        let i = 0;
        while (i < length) {
            let number = *vector::borrow(&numbers, i);
            let flag = is_prime(number);
            let status = PrimeStatus<bool> {
                number,
                is_prime: flag,
                marker: true,
            };
            vector::push_back(&mut results, status);
            i = i + 1;
        };
        results
    }
}


//# run 0xCAFE::PrimeChecker::is_prime --args 0u64


//# run 0xCAFE::PrimeChecker::is_prime --args 1u64


//# run 0xCAFE::PrimeChecker::is_prime --args 2u64


//# run 0xCAFE::PrimeChecker::is_prime --args 3u64


//# run 0xCAFE::PrimeChecker::is_prime --args 4u64


//# run 0xCAFE::PrimeChecker::is_prime --args 17u64


//# run 0xCAFE::PrimeChecker::example_status


//# run 0xCAFE::PrimeChecker::check_primes --args vector[0u64, 1u64, 2u64, 3u64, 4u64, 17u64, 18u64, 19u64]


// Featurres:
// 4076ee37cbaf26a4bb3047187e51c642: Test that the is_prime function correctly determines whether given u64 integers are prime numbers, including various edge cases.
// 5f0bdd6ad1a7efa983e75c7cc96d83a6: Specify optional type parameters within the specification pattern.
// e77687d6a2d417d3ab8f6c23ee9482d8: Use primitive types in type definitions.
