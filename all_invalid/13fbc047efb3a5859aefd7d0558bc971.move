
//# publish
module 0xCAFE::UnreachableCodeTest {
    use std::vector;
    use std::assert;

    // Function to test parsing of empty list
    public fun test_empty_list(): vector<u8> {
        let empty_vec: vector<u8> = vector::empty<u8>();
        empty_vec
    }

    // Function to test pow implementation
    public fun test_pow(base: u64, exp: u64): u64 {
        // Using recursive helper for pow
        pow_recursive(base, exp)
    }

    fun pow_recursive(base: u64, exp: u64): u64 {
        if (exp == 0) {
            1
        } else {
            base * pow_recursive(base, exp - 1)
        }
    }

    // Function to include unreachable code
    public fun unreachable_code_example(flag: bool): u64 {
        if (flag) {
            42
        } else {
            // Unreachable if we can guarantee flag is always true in test
            let _ = unreachable_code(); // should be flagged by UnreachableCodeProcessor
            0
        }
    }

    fun unreachable_code(): u64 {
        // This code is intentionally unreachable in certain contexts
        abort 999
    }
}


//# run 0xCAFE::UnreachableCodeTest::test_empty_list


//# run 0xCAFE::UnreachableCodeTest::test_pow --args 2u64 10u64


//# run 0xCAFE::UnreachableCodeTest::test_pow --args 5u64 0u64


//# run 0xCAFE::UnreachableCodeTest::unreachable_code_example --args true


// Featurres:
// 7282f71ab15dd29def3d23bb4a2e2dad: Allow parsing of empty lists when the end token immediately follows the start.
// 4613687a465c9d27bbe9e991edc38d39: Test the `pow` function to ensure it correctly computes exponentiation for various base and exponent values, including the case where the exponent is zero.
// 917c063b5b68d92224f704f1b8f6b3bc: Use UnreachableCodeProcessor to identify unreachable code segments.
