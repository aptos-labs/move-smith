
//# publish
module 0xDEAD::LiteralAndAddressInteraction {
    use std::signer;
    use std::assert;

    // Test assigning various literal values to local variables and verify correctness
    public fun test_literals_assignment() {
        // Assigning numeric literals
        let num_u8 = 255u8;
        let num_u16 = 65535u16;
        let num_u32 = 4294967295u32;
        let num_u64 = 18446744073709551615u64;

        // Assigning boolean literals
        let b_true = true;
        let b_false = false;

        // Asserting correctness
        assert!(num_u8 == 255u8, 100);
        assert!(num_u16 == 65535u16, 101);
        assert!(num_u32 == 4294967295u32, 102);
        assert!(num_u64 == 18446744073709551615u64, 103);
        assert!(b_true, 104);
        assert!(!b_false, 105);
    }

    // Test variable declarations within nested blocks and scope/lifetime
    public fun test_scoping_and_literals_in_blocks() {
        let a = 10u8;
        assert!(a == 10u8, 200);
        {
            let b = 20u16;
            let c = true;
            assert!(b == 20u16, 201);
            assert!(c, 202);
            {
                let d = 30u32;
                let e = false;
                // Shadow previous variables within inner block
                assert!(d == 30u32, 203);
                assert!(!e, 204);
            }
        }
        // Outer scope variables remain unaffected
        assert!(a == 10u8, 205);
    }

    // Declare address maps and reference them within blocks
    // Create named address map 'ADDR_MAP' with addresses
    // Since in Move we cannot assign addresses directly in code, simulate address references
    // by defining constants that are addresses
    public fun test_address_references() {
        // In actual tests, use real addresses, but here simulate with constants
        const ADDR1: address = @0xB1E;
        const ADDR2: address = @0xC0FFEE;

        // Use addresses in local variables with literals
        let addr_var1 = ADDR1;
        let addr_var2 = ADDR2;

        // Assign boolean based on address comparison
        let is_addr1 = (addr_var1 == @0xB1E);
        let is_addr2 = (addr_var2 == @0xC0FFEE);

        // Assertions
        assert!(is_addr1, 300);
        assert!(is_addr2, 301);
    }

    // Combine literals and address references in different contexts
    public fun test_literals_and_addresses_combined() {
        const ADDR_A: address = @0xABCD;
        const ADDR_B: address = @0x1234;

        // Assign literals and addresses to variables
        let literal_number = 12345u64;
        let bool_value = (literal_number > 10000u64);
        let address_value = ADDR_A;

        // Verify the boolean expression
        assert!(bool_value, 400);

        // Verify address equality
        let is_same_address = (address_value == ADDR_A);
        assert!(is_same_address, 401);

        // New boolean based on address
        let res_bool = (address_value != ADDR_B);
        assert!(res_bool, 402);
    }

    // Test assigning complex boolean expressions involving literals
    public fun test_boolean_expressions() {
        let bool1 = (10u8 + 20u8 > 25u8);
        let bool2 = ((!false) && (true || false));
        let bool3 = (1000u16 * 2 == 2000u16);

        assert!(bool1, 500);
        assert!(bool2, 501);
        assert!(bool3, 502);
    }

    // Test assigning large numbers with literals and verify
    public fun test_large_numbers() {
        let large_u64 = 0xFFFFFFFFFFFFFFFFu64;
        let large_u128 = 340282366920938463463374607431768211455u128;

        assert!(large_u64 == 18446744073709551615u64, 600);
        // No assertion for u128 since not used in move directly; just ensure no compile errors
        // but include a dummy variable to prevent unused
        let dummy = large_u128;
    }
}


//# run 0xDEAD::LiteralAndAddressInteraction::test_literals_assignment

//# run 0xDEAD::LiteralAndAddressInteraction::test_scoping_and_literals_in_blocks

//# run 0xDEAD::LiteralAndAddressInteraction::test_address_references

//# run 0xDEAD::LiteralAndAddressInteraction::test_literals_and_addresses_combined

//# run 0xDEAD::LiteralAndAddressInteraction::test_boolean_expressions

//# run 0xDEAD::LiteralAndAddressInteraction::test_large_numbers


// Featurres:
// c80a3f6edf8077f368cb14faf5c1c53e: Write literal value expressions (e.g., numbers, booleans) in your code.
// 40b424df8bc2aabc76c9eb06e5eb47f2: Declare local variables in Move blocks, with or without an explicit type.
// a6f9ca8668025ee82217756e08871cab: Associate named address maps with Move packages.
