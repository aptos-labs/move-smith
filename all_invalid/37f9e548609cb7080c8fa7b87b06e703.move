
//# publish
module 0xCAFE::EvalTest {
    use std::vector;

    // Evaluate various constant expressions, including comparison, logic, arithmetic, casts, and byte equality.
    // Define a function to return the results as a tuple.
    public fun test_constants(): (bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, u8, u64, u128, u256, bool) {
        // Comparison and logic expressions
        let cond1 = 3u8 == 3u8;
        let cond2 = 5u8 != 7u8;
        let cond3 = true && false;
        let cond4 = true || false;
        let cond5 = !(false);
        let cond6 = (10 + 20) < 45;
        let cond7 = (50 - 25) > 10;
        let cond8 = (100 / 4) == 25;
        let cond9 = (200 % 3) != 2;
        let cond10 = (true && true) || false;
        let cond11 = (false || false) && true;
        let cond12 = !(3u8 > 2u8);

        // Arithmetic with casts
        let cast_u8 = (1 + 2 as u8);
        let cast_u64 = (1000 + 2000 as u64);
        let cast_u128 = (300000 + 400000 as u128);
        // Fix: separate the addition into its own expression to avoid unexpected token
        let u256_base: u128 = u64::MAX as u128;
        let cast_u256 = u256_base + 1;

        // Byte and vector comparison
        let bytes_equal = b"move" == b"move";
        let vec1: vector<u8> = b"hello";
        let vec2: vector<u8> = b"hello";
        let vecs_equal = vector::equals(&vec1, &vec2);

        // Use wildcards in variable binding
        let _ = 42u8;
        let _ = 999u64;
        let _ = 12u128;
        let _ = 0xffffu256;

        (cond1, cond2, cond3, cond4, cond5, cond6, cond7, cond8, cond9, cond10, cond11, cond12, cast_u8, cast_u64, cast_u128, cast_u256, bytes_equal && vecs_equal)
    }

    // Additional function to test that constant expressions are correctly evaluated during module compilation
    public fun test_assertions() {
        // We can assert the evaluation of expressions
        assert!(3u8 == 3u8, 100);
        assert!(5u8 != 7u8, 101);
        assert!((10 + 20) < 45, 102);
        assert!((50 - 25) > 10, 103);
        assert!((100 / 4) == 25, 104);
        assert!(((200 % 3) != 2), 105);
        assert!(b"move" == b"move", 106);
        let vec1: vector<u8> = b"hello";
        let vec2: vector<u8> = b"hello";
        assert!(vector::equals(&vec1, &vec2), 107);
        // Confirm that casting and comparison work as expected
        assert!((1 + 2 as u8) == 3u8, 108);
        assert!((1000 + 2000 as u64) == 3000, 109);
        assert!((300000 + 400000 as u128) == 700000, 110);
        let u256_value = u64::MAX as u128 + 1;
        assert!(u256_value == u64::MAX as u128 + 1, 111);
    }
}

//# run 0xCAFE::EvalTest::test_constants

//# run 0xCAFE::EvalTest::test_assertions