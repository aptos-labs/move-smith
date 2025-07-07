module 0xCAFE::OperatorPrecedenceTest {
    use std::address;

    // Entry point to run the precedence test
    public entry fun test_precedence() {
        // Logical operators precedence test: (true && false) || true == true
        let logical_result = (true && false) || true;
        assert!(logical_result, 100);

        // Comparison operators precedence test: 3 + 2 * 5 == 3 + (2 * 5)
        let cmp_result = (3 + 2 * 5) == (3 + (2 * 5));
        assert!(cmp_result, 101);

        // Bitwise operators precedence test:
        // Move does not support binary literals like 0b1010.
        // Instead, use hexadecimal literals for clarity.
        let val1 = 0xA;   // 0b1010 == 0xA
        let val2 = 0xC;   // 0b1100 == 0xC
        let val3 = 0x3;   // 0b0011 == 0x3

        let bitwise_result = (val1 & val2) | val3;
        // (0xA & 0xC) = 0x8, 0x8 | 0x3 = 0xB
        assert!(bitwise_result == 0xB, 102);

        // Address equality between decimal and hexadecimal address literals
        // Use address literals directly
        let addr_dec = address::from_bytes(&(0xCAFE as u64).to_le_bytes());
        let addr_hex = address::from_bytes(&(0xCAFE as u64).to_le_bytes());

        // Assert they are equal
        assert!(address::equal(&addr_dec, &addr_hex), 103);
    }
}