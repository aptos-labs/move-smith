module 0xCAFE::UnreachableCodeTest {
    use std::vector;

    // Note: 'std::assert' does not exist in current Move standard library.
    // Remove the invalid 'use std::assert;' statement to fix compilation error.

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