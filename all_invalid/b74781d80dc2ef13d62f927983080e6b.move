
//# publish
module 0xCAFE::BitwiseOps {
    use std::vector;
    use std::u256;

    // Test bitwise AND for various unsigned integer types and edge cases
    public fun test_and_u8(): u8 {
        let zero: u8 = 0u8;
        let max: u8 = 0xFFu8;
        let val: u8 = 0xAAu8; // 0b10101010
        let and1 = zero & val; // 0 & val = 0
        let and2 = max & val;  // max & val = val
        let and3 = val & val;  // val & val = val
        and1 + and2 + and3
    }

    public fun test_and_u16(): u16 {
        let zero: u16 = 0u16;
        let max: u16 = 0xFFFFu16;
        let val: u16 = 0xAAAAu16; // 0b1010101010101010
        let and1 = zero & val;
        let and2 = max & val;
        let and3 = val & val;
        and1 + and2 + and3
    }

    public fun test_and_u32(): u32 {
        let zero: u32 = 0u32;
        let max: u32 = 0xFFFFFFFFu32;
        let val: u32 = 0xAAAAAAAAu32;
        let and1 = zero & val;
        let and2 = max & val;
        let and3 = val & val;
        and1 + and2 + and3
    }

    public fun test_and_u64(): u64 {
        let zero: u64 = 0u64;
        let max: u64 = 0xFFFFFFFFFFFFFFFFu64;
        let val: u64 = 0xAAAAAAAAAAAAAAAAu64;
        let and1 = zero & val;
        let and2 = max & val;
        let and3 = val & val;
        and1 + and2 + and3
    }

    public fun test_and_u128(): u128 {
        let zero: u128 = 0u128;
        let max: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let val: u128 = 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAu128;
        let and1 = zero & val;
        let and2 = max & val;
        let and3 = val & val;
        and1 + and2 + and3
    }

    public fun test_and_u256(): u256 {
        let zero: u256 = 0u256;
        let max: u256 = !zero;
        // define some mixed value for u256 (32 bytes), here the pattern 0xAA
        let val_bytes = vector::repeat<u8>(0xAAu8, 32);
        let val = u256::from_le_bytes(&val_bytes);
        let and1 = zero & val;
        let and2 = max & val;
        let and3 = val & val;
        and1 + and2 + and3
    }

    // Test bitwise OR for various unsigned integer types and edge cases
    public fun test_or_u8(): u8 {
        let zero: u8 = 0u8;
        let max: u8 = 0xFFu8;
        let val: u8 = 0x55u8; // 0b01010101
        let or1 = zero | val; // val
        let or2 = max | val;  // max
        let or3 = val | val;  // val
        or1 + or2 + or3
    }

    public fun test_or_u16(): u16 {
        let zero: u16 = 0u16;
        let max: u16 = 0xFFFFu16;
        let val: u16 = 0x5555u16;
        let or1 = zero | val;
        let or2 = max | val;
        let or3 = val | val;
        or1 + or2 + or3
    }

    public fun test_or_u32(): u32 {
        let zero: u32 = 0u32;
        let max: u32 = 0xFFFFFFFFu32;
        let val: u32 = 0x55555555u32;
        let or1 = zero | val;
        let or2 = max | val;
        let or3 = val | val;
        or1 + or2 + or3
    }

    public fun test_or_u64(): u64 {
        let zero: u64 = 0u64;
        let max: u64 = 0xFFFFFFFFFFFFFFFFu64;
        let val: u64 = 0x5555555555555555u64;
        let or1 = zero | val;
        let or2 = max | val;
        let or3 = val | val;
        or1 + or2 + or3
    }

    public fun test_or_u128(): u128 {
        let zero: u128 = 0u128;
        let max: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let val: u128 = 0x55555555555555555555555555555555u128;
        let or1 = zero | val;
        let or2 = max | val;
        let or3 = val | val;
        or1 + or2 + or3
    }

    public fun test_or_u256(): u256 {
        let zero: u256 = 0u256;
        let max: u256 = !zero;
        let val_bytes = vector::repeat<u8>(0x55u8, 32);
        let val = u256::from_le_bytes(&val_bytes);
        let or1 = zero | val;
        let or2 = max | val;
        let or3 = val | val;
        or1 + or2 + or3
    }

    // Test bitwise XOR for various unsigned integer types and edge cases
    public fun test_xor_u8(): u8 {
        let zero: u8 = 0u8;
        let max: u8 = 0xFFu8;
        let val1: u8 = 0xF0u8;
        let val2: u8 = 0xAAu8;
        let xor1 = zero ^ val1;      // val1
        let xor2 = max ^ val1;       // not val1
        let xor3 = val1 ^ val1;      // 0
        let xor4 = val1 ^ val2;      // mixed
        xor1 + xor2 + xor3 + xor4
    }

    public fun test_xor_u16(): u16 {
        let zero: u16 = 0u16;
        let max: u16 = 0xFFFFu16;
        let val1: u16 = 0xF0F0u16;
        let val2: u16 = 0xAAAAu16;
        let xor1 = zero ^ val1;
        let xor2 = max ^ val1;
        let xor3 = val1 ^ val1;
        let xor4 = val1 ^ val2;
        xor1 + xor2 + xor3 + xor4
    }

    public fun test_xor_u32(): u32 {
        let zero: u32 = 0u32;
        let max: u32 = 0xFFFFFFFFu32;
        let val1: u32 = 0xF0F0F0F0u32;
        let val2: u32 = 0xAAAAAAAAu32;
        let xor1 = zero ^ val1;
        let xor2 = max ^ val1;
        let xor3 = val1 ^ val1;
        let xor4 = val1 ^ val2;
        xor1 + xor2 + xor3 + xor4
    }

    public fun test_xor_u64(): u64 {
        let zero: u64 = 0u64;
        let max: u64 = 0xFFFFFFFFFFFFFFFFu64;
        let val1: u64 = 0xF0F0F0F0F0F0F0F0u64;
        let val2: u64 = 0xAAAAAAAAAAAAAAAAu64;
        let xor1 = zero ^ val1;
        let xor2 = max ^ val1;
        let xor3 = val1 ^ val1;
        let xor4 = val1 ^ val2;
        xor1 + xor2 + xor3 + xor4
    }

    public fun test_xor_u128(): u128 {
        let zero: u128 = 0u128;
        let max: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let val1: u128 = 0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0u128;
        let val2: u128 = 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAu128;
        let xor1 = zero ^ val1;
        let xor2 = max ^ val1;
        let xor3 = val1 ^ val1;
        let xor4 = val1 ^ val2;
        xor1 + xor2 + xor3 + xor4
    }

    public fun test_xor_u256(): u256 {
        let zero: u256 = 0u256;
        let max: u256 = !zero;
        let val1_bytes = vector::repeat<u8>(0xF0u8, 32);
        let val2_bytes = vector::repeat<u8>(0xAAu8, 32);
        let val1 = u256::from_le_bytes(&val1_bytes);
        let val2 = u256::from_le_bytes(&val2_bytes);
        let xor1 = zero ^ val1;
        let xor2 = max ^ val1;
        let xor3 = val1 ^ val1;
        let xor4 = val1 ^ val2;
        xor1 + xor2 + xor3 + xor4
    }

    // Runner function to test all bitwise ops (AND, OR, XOR) for all types
    public fun runner(): u8 {
        let sum_u8 = test_and_u8() + test_or_u8() + test_xor_u8();
        let sum_u16 = (test_and_u16() + test_or_u16() + test_xor_u16()) as u8;
        let sum_u32 = (test_and_u32() + test_or_u32() + test_xor_u32()) as u8;
        let sum_u64 = (test_and_u64() + test_or_u64() + test_xor_u64()) as u8;
        let sum_u128 = (test_and_u128() + test_or_u128() + test_xor_u128()) as u8;
        let sum_u256 = (test_and_u256() + test_or_u256() + test_xor_u256()) as u8;
        sum_u8 + sum_u16 + sum_u32 + sum_u64 + sum_u128 + sum_u256
    }
}



//# run 0xCAFE::BitwiseOps::runner
