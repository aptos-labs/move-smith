//# publish
module 0xtest::sequential_test {
    fun seq_value(x: u64): u64 {
        let temp1 = x;
        let temp2 = temp1;
        let temp3 = temp2;
        let temp4 = temp3;
        let result = temp4;
        result
    }

    public fun run_sequential() {
        assert!(seq_value(0) == 0, 0);
        assert!(seq_value(42) == 42, 1);
        assert!(seq_value(99999) == 99999, 2);
        // Test with large value
        assert!(seq_value(18446744073709551615) == 18446744073709551615, 3);
    }
}

//# run 0xtest::sequential_test::run_sequential


//# publish
module 0xtest::arithmetic_boundaries {
    fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    fun sub_u8(a: u8, b: u8): u8 {
        a - b
    }

    fun mul_u8(a: u8, b: u8): u8 {
        a * b
    }

    public fun main() {
        // Valid operations
        assert!(add_u8(0, 0) == 0, 0);
        assert!(add_u8(255, 0) == 255, 1);
        assert!(add_u8(1, 254) == 255, 2);

        assert!(sub_u8(255, 0) == 255, 3);
        assert!(sub_u8(10, 5) == 5, 4);
        assert!(sub_u8(0, 0) == 0, 5);
        // Attempt overflow addition (should trap, but in test we simply attempt)
        // assert!(add_u8(255, 1) == ???, trap);
        // Attempt underflow subtraction (should trap)
        // assert!(sub_u8(0, 1) == ???, trap);

        assert!(mul_u8(0, 255) == 0, 6);
        assert!(mul_u8(2, 128) == 256u8, 7); // 256 overflows to 0 in u8
        assert!(mul_u8(15, 17) == 255, 8);
        // Multiplication overflow test intentionally omitted as it would trap
    }
}

//# run 0xtest::arithmetic_boundaries::main


//# publish
module 0xtest::division_and_modulo {
    fun div_u8(a: u8, b: u8): u8 {
        a / b
    }

    fun mod_u8(a: u8, b: u8): u8 {
        a % b
    }

    public fun test_div_and_mod() {
        assert!(div_u8(10, 2) == 5, 0);
        assert!(div_u8(255, 1) == 255, 1);
        assert!(mod_u8(10, 3) == 1, 2);
        assert!(mod_u8(255, 16) == 15, 3);
    }
}

//# run 0xtest::division_and_modulo::test_div_and_mod

//# run
script {
fun main() {
    // Expected to succeed
    assert!(0u8 / 1u8 == 0, 0);
    assert!(1u8 / 1u8 == 1, 1);
    assert!(255u8 / 255u8 == 1, 2);
}
}

//# run
script {
fun main() {
    // Should trap: division by zero
    10u8 / 0u8;
}
}

//# run
script {
fun main() {
    // Should trap: modulus by zero
    20u8 % 0u8;
}
}


//# publish
module 0xtest::mixed_interactions {
    fun combined_operations(val: u64): u64 {
        let sum = val + 10;
        let diff = sum - 3;
        let prod = diff * 2;
        prod
    }

    public fun run_combined() {
        assert!(combined_operations(0) == 14, 0);
        assert!(combined_operations(100) == 214, 1);
        assert!(combined_operations(1844674407370955161) == 366935440737095032, 2);
    }
}

//# run 0xtest::mixed_interactions::run_combined