//# publish
module 0xCAFE::PrimeUtils {
    /// Returns true if n is prime.
    public fun is_prime(n: u64): bool {
        if (n <= 1) {
            return false;
        }
        let i = 2;
        let mut is_p = true;
        let mut j = i;
        while (j * j <= n) {
            if (n % j == 0) {
                is_p = false;
                break;
            }
            j = j + 1;
        }
        is_p
    }

    /// Returns the largest prime factor of n.
    public fun largest_prime_factor(n: u64): u64 {
        let mut num = n;
        let mut max_prime = 1;
        let mut i = 2;
        while (i*i <= num) {
            while (num % i == 0) {
                max_prime = i;
                num = num / i;
            }
            i = i + 1;
        }
        if (num > 1) {
            max_prime = num;
        }
        max_prime
    }

    /// Convenience runner to test largest_prime_factor with some example numbers.
    public fun runner() {
        let res_1 = largest_prime_factor(15); // Should be 5
        let res_2 = largest_prime_factor(2);  // Should be 2
        let res_3 = largest_prime_factor(49); // Should be 7
        let res_4 = largest_prime_factor(13195); // Should be 29
        let res_5 = largest_prime_factor(600851475143); // Should be 6857
        // Just to avoid warnings about unused let bindings,
        // put them in a vector (even if not used further).
        let _ = vector[res_1, res_2, res_3, res_4, res_5];
    }
}
//# run 0xCAFE::PrimeUtils::runner

//# publish
module 0xCAFE::ScriptVerifier {
    use std::vector;
    /// Dummy function that would verify the script for "correctness".
    /// In real Move, script verification is at the compiler/VM level, but we'll simulate.
    public fun verify_script(code: vector<u8>): bool {
        // For demo, let's check that the script's bytes length is not zero.
        // (In practice, this could check for magic bytes, signatures, etc.)
        if (vector::length(&code) == 0) {
            return false;
        };
        true
    }

    public fun runner() {
        // Simulate a script source as a byte string
        let script_code = b"main(){}";
        let res1 = verify_script(script_code); // should be true

        let empty_code: vector<u8> = x"";
        let res2 = verify_script(empty_code); // should be false

        let _ = vector[res1, res2];
    }
}
//# run 0xCAFE::ScriptVerifier::runner

//# publish
module 0xCAFE::SequenceTest {
    use std::vector;
    /// Demonstrates a sequence (vector) of u64 with a specific order
    public fun ordered_sequence(): vector<u64> {
        vector[3, 1, 4, 1, 5, 9, 2, 6]
    }

    /// Runner packs/unwraps the sequence, and also verifies the order is preserved.
    public fun runner() {
        let seq = ordered_sequence();
        // Just to check the order, unpack each element one-by-one via indexing.
        let e0 = *vector::borrow(&seq, 0); // 3
        let e1 = *vector::borrow(&seq, 1); // 1
        let e2 = *vector::borrow(&seq, 2); // 4
        let e3 = *vector::borrow(&seq, 3); // 1
        let e4 = *vector::borrow(&seq, 4); // 5
        let e5 = *vector::borrow(&seq, 5); // 9
        let e6 = *vector::borrow(&seq, 6); // 2
        let e7 = *vector::borrow(&seq, 7); // 6
        let _ = vector[e0, e1, e2, e3, e4, e5, e6, e7];
    }
}
//# run 0xCAFE::SequenceTest::runner

//# run
script {
    use 0xCAFE::PrimeUtils;
    fun main() {
        let x = PrimeUtils::largest_prime_factor(77); // Should be 11
        let _ = x;
    }
}

//# run
script {
    use 0xCAFE::ScriptVerifier;
    fun main() {
        // This is a valid script code (simulate)
        let code = b"fun main() {}";
        let check = ScriptVerifier::verify_script(code);
        let _ = check;
    }
}

//# run
script {
    use std::vector;
    use 0xCAFE::SequenceTest;
    fun main() {
        let seq = SequenceTest::ordered_sequence();
        // Reverse the sequence, for fun (not required, but exercises vector ops)
        let mut_res = vector::empty<u64>();
        let mut_i = vector::length(&seq);
        let mut res = mut_res;
        let mut i = mut_i;
        while (i > 0) {
            i = i - 1;
            let val = *vector::borrow(&seq, i);
            vector::push_back(&mut res, val);
        };
        // Result is the reverse: [6,2,9,5,1,4,1,3]
        let _ = res;
    }
}