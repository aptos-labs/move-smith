//# publish
module 0xDEADBEEF::TestOperations {
    use 0xDEADBEEF::Assertions;

    fun run_operations() {
        // Integer comparisons and arithmetic
        let int_eq: bool = 10 == 10;
        let int_neq: bool = 20 != 15;
        let int_add: u64 = 100 + 200;
        let int_sub: u64 = 300 - 50;
        let int_mul: u64 = 7 * 6;
        let int_div: u64 = 100 / 4;
        let int_mod: u64 = 55 % 6;

        // Boolean logic
        let bool_and: bool = false && true;
        let bool_or: bool = false || true;
        let bool_not: bool = !false;

        // Byte and hex operations
        let byte_a: u8 = 0xA;
        let byte_b: u8 = 0xB;
        let byte_and: u8 = byte_a & byte_b;
        let byte_or: u8 = byte_a | byte_b;
        let byte_xor: u8 = byte_a ^ byte_b;

        // Shift operations
        let shift_left: u64 = 1 << 4; // 16
        let shift_right: u64 = shift_left >> 2; // 4

        // Bitwise operations with larger types
        let u128_a: u128 = 1 << 127;
        let u128_b: u128 = (1 << 64) + 1;
        let u128_and: u128 = u128_a & u128_b;
        let u128_or: u128 = u128_a | u128_b;
        let u128_xor: u128 = u128_a ^ u128_b;

        // Combining all
        assert!(int_eq, 1);
        assert!(int_neq, 2);
        assert!(int_add == 300, 3);
        assert!(int_sub == 250, 4);
        assert!(int_mul == 42, 5);
        assert!(int_div == 25, 6);
        assert!(int_mod == 55 % 6, 7);
        assert!(!bool_and, 8);
        assert!(bool_or, 9);
        assert!(bool_not, 10);
        assert!(byte_and == 0xA & 0xB, 11);
        assert!(byte_or == 0xA | 0xB, 12);
        assert!(byte_xor == 0xA ^ 0xB, 13);
        assert!(shift_left == 16, 14);
        assert!(shift_right == 4, 15);
        assert!(u128_a & u128_b == 0x80000000000000000000000000000001, 16);
        assert!(u128_a | u128_b == 0x80000000000000010000000000000001, 17);
        assert!(u128_xor == 0x80000000000000000000000000000000, 18);
    }

    //# run
script {
    run_operations();
}
}