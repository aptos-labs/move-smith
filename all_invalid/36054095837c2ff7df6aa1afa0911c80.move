
//# publish
module 0xCAFE::ComparisonOperators {
    use std::signer;

    // Private helper function to test comparisons of u8 values
    fun compare_u8(a: u8, b: u8): bool {
        assert!(a == b == (a == b), 0);
        assert!(a != b == (a != b), 1);
        assert!(a < b == (a < b), 2);
        assert!(a > b == (a > b), 3);
        assert!(a <= b == (a <= b), 4);
        assert!(a >= b == (a >= b), 5);
        true
    }

    fun compare_u16(a: u16, b: u16): bool {
        assert!(a == b == (a == b), 6);
        assert!(a != b == (a != b), 7);
        assert!(a < b == (a < b), 8);
        assert!(a > b == (a > b), 9);
        assert!(a <= b == (a <= b), 10);
        assert!(a >= b == (a >= b), 11);
        true
    }

    fun compare_u32(a: u32, b: u32): bool {
        assert!(a == b == (a == b), 12);
        assert!(a != b == (a != b), 13);
        assert!(a < b == (a < b), 14);
        assert!(a > b == (a > b), 15);
        assert!(a <= b == (a <= b), 16);
        assert!(a >= b == (a >= b), 17);
        true
    }

    fun compare_u64(a: u64, b: u64): bool {
        assert!(a == b == (a == b), 18);
        assert!(a != b == (a != b), 19);
        assert!(a < b == (a < b), 20);
        assert!(a > b == (a > b), 21);
        assert!(a <= b == (a <= b), 22);
        assert!(a >= b == (a >= b), 23);
        true
    }

    fun compare_u128(a: u128, b: u128): bool {
        assert!(a == b == (a == b), 24);
        assert!(a != b == (a != b), 25);
        assert!(a < b == (a < b), 26);
        assert!(a > b == (a > b), 27);
        assert!(a <= b == (a <= b), 28);
        assert!(a >= b == (a >= b), 29);
        true
    }

    fun compare_u256(a: u256, b: u256): bool {
        assert!(a == b == (a == b), 30);
        assert!(a != b == (a != b), 31);
        assert!(a < b == (a < b), 32);
        assert!(a > b == (a > b), 33);
        assert!(a <= b == (a <= b), 34);
        assert!(a >= b == (a >= b), 35);
        true
    }

    // Public(friend) functions to expose comparison tests
    public(friend) fun test_u8_comparisons() {
        compare_u8(5u8, 5u8);
        compare_u8(3u8, 7u8);
        compare_u8(9u8, 2u8);
    }

    public(friend) fun test_u16_comparisons() {
        compare_u16(5u16, 5u16);
        compare_u16(3u16, 7u16);
        compare_u16(9u16, 2u16);
    }

    public(friend) fun test_u32_comparisons() {
        compare_u32(5u32, 5u32);
        compare_u32(3u32, 7u32);
        compare_u32(9u32, 2u32);
    }

    public(friend) fun test_u64_comparisons() {
        compare_u64(5u64, 5u64);
        compare_u64(3u64, 7u64);
        compare_u64(9u64, 2u64);
    }

    public(friend) fun test_u128_comparisons() {
        compare_u128(5u128, 5u128);
        compare_u128(3u128, 7u128);
        compare_u128(9u128, 2u128);
    }

    public(friend) fun test_u256_comparisons() {
        compare_u256(5u256, 5u256);
        compare_u256(3u256, 7u256);
        compare_u256(9u256, 2u256);
    }

    // A runner test function that calls all friend test functions
    public fun run_all() {
        test_u8_comparisons();
        test_u16_comparisons();
        test_u32_comparisons();
        test_u64_comparisons();
        test_u128_comparisons();
        test_u256_comparisons();
    }
}


//# run 0xCAFE::ComparisonOperators::run_all



//# publish
module 0xDEAD::Caller {
    use 0xCAFE::ComparisonOperators;

    public fun call_friend_functions() {
        // Call public(friend) functions from 0xCAFE::ComparisonOperators, allowed because declared as friend
        ComparisonOperators::test_u8_comparisons();
        ComparisonOperators::test_u16_comparisons();
        ComparisonOperators::test_u32_comparisons();
        ComparisonOperators::test_u64_comparisons();
        ComparisonOperators::test_u128_comparisons();
        ComparisonOperators::test_u256_comparisons();
    }
}


//# run 0xDEAD::Caller::call_friend_functions


// Featurres:
// 19ce835471001d192c399996ca1ebb98: Address modules by account address or by address alias in module imports and references.
// cb43a6730038524c90a860212e3eb3fb: Restrict visibility of functions and modules to friends using the 'public(friend)' visibility modifier.
// 7553b3396efb5ff4938a88b0a953cbe8: Test all comparison operators (==, !=, <, >, <=, >=) for all unsigned integer types (u8, u16, u32, u64, u128, u256) to ensure they behave correctly for equal, lesser, and greater values.
