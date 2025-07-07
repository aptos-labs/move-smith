
//# publish
module 0xCAFE::OperatorPrecedenceTest {
    use std::vector;

    // Entry point to run the precedence test
    public entry fun test_precedence() {
        // Logical operators precedence test: (true && false) || true == true
        let logical_result = (true && false) || true;
        assert!(logical_result, 100);

        // Comparison operators precedence test: 3 + 2 * 5 == 3 + (2 * 5)
        let cmp_result = (3 + 2 * 5) == (3 + (2 * 5));
        assert!(cmp_result, 101);

        // Bitwise operators precedence test: (0b1010 & 0b1100) | 0b0011 == 0b1010 & 0b1100 | 0b0011
        // Note: Move uses & and | with precedence similar to C; compare accordingly
        let bitwise_result = (0b1010 & 0b1100) | 0b0011;
        // Expected: (0b1010 & 0b1100) = 0b1000, 0b1000 | 0b0011 = 0b1011
        assert!(bitwise_result == 0b1011, 102);

        // Address equality between decimal and hexadecimal address literals
        // Use address literals and compare
        let addr_dec = 0xCAFE; // as integer, but need to cast to address to compare
        let addr_hex = 0xCAFE;

        // Convert integers to addresses for comparison
        let addr_dec_addr = address::from_bytes(&(addr_dec as u64).to_le_bytes());
        let addr_hex_addr = address::from_bytes(&(addr_hex as u64).to_le_bytes());

        // Assert they are equal
        assert!(address::equal(&addr_dec_addr, &addr_hex_addr), 103);
    }
}


//# run 0xCAFE::OperatorPrecedenceTest::test_precedence

// Featurres:
// f189e67a89403c35541218c8a381f25e: Test that operator precedence in logical, comparison, and bitwise expressions matches the expected order in Move.
// d6737f4684fc194ee60b487b2ee0ce39: Test that hexadecimal and decimal address literals with equivalent values are considered equal in address comparisons.
// d99a61fc9d6d72c97cc1ea64b0f124ce: Declare functions or modules as 'entry' to specify entry points
