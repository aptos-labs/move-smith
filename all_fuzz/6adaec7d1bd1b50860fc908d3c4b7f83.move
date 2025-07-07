
//# publish
module 0xCAFE::IntegerOps {
    // Demonstrate module constants
    const CONST_U8: u8 = 0x12;       // 18 decimal
    const CONST_U16: u16 = 0x1234;   // 4660 decimal
    const CONST_U32: u32 = 0x12345678;
    const CONST_U64: u64 = 0x123456789ABCDEF0;

    public fun example_constants(): (u8, u16, u32, u64) {
        (CONST_U8, CONST_U16, CONST_U32, CONST_U64)
    }

    // Test shifts, division, modulo, and bitwise ops for u8
    public fun test_u8(input: u8): u8 {
        let shifted_left = input << 2;
        let shifted_right = input >> 1;
        let divided = input / 2;
        let modulo = input % 5;
        let added = input + 10;
        let subtracted = input - 3;
        let anded = input & 0x0F;
        let ored = input | 0xF0;
        let xored = input ^ 0xFF;

        // return a combined value by adding all results mod 256
        let combined = shifted_left + shifted_right + divided + modulo + added + subtracted + anded + ored + xored;
        combined
    }

    // Test shifts, division, modulo, and bitwise ops for u16
    public fun test_u16(input: u16): u16 {
        let shifted_left = input << 4;
        let shifted_right = input >> 3;
        let divided = input / 3;
        let modulo = input % 7;
        let added = input + 100;
        let subtracted = input - 50;
        let anded = input & 0x00FF;
        let ored = input | 0xFF00;
        let xored = input ^ 0xFFFF;

        let combined = shifted_left;
        combined = combined + shifted_right;
        combined = combined + divided;
        combined = combined + modulo;
        combined = combined + added;
        combined = combined + subtracted;
        combined = combined + anded;
        combined = combined + ored;
        combined = combined + xored;
        combined
    }

    // Test shifts, division, modulo, and bitwise ops for u32
    public fun test_u32(input: u32): u32 {
        let shifted_left = input << 8;
        let shifted_right = input >> 4;
        let divided = input / 10;
        let modulo = input % 11;
        let added = input + 1000;
        let subtracted = input - 500;
        let anded = input & 0x0000FFFF;
        let ored = input | 0xFFFF0000;
        let xored = input ^ 0xFFFFFFFF;

        let combined = shifted_left;
        combined = combined + shifted_right;
        combined = combined + divided;
        combined = combined + modulo;
        combined = combined + added;
        combined = combined + subtracted;
        combined = combined + anded;
        combined = combined + ored;
        combined = combined + xored;
        combined
    }

    // Test shifts, division, modulo, and bitwise ops for u64
    public fun test_u64(input: u64): u64 {
        let shifted_left = input << 16;
        let shifted_right = input >> 8;
        let divided = input / 100;
        let modulo = input % 17;
        let added = input + 10000;
        let subtracted = input - 5000;
        let anded = input & 0x00000000FFFFFFFF;
        let ored = input | 0xFFFFFFFF00000000;
        let xored = input ^ 0xFFFFFFFFFFFFFFFF;

        let combined = shifted_left;
        combined = combined + shifted_right;
        combined = combined + divided;
        combined = combined + modulo;
        combined = combined + added;
        combined = combined + subtracted;
        combined = combined + anded;
        combined = combined + ored;
        combined = combined + xored;
        combined
    }

    // Test type casting u64 -> u32 -> u16 -> u8 and back
    public fun test_casting(x: u64): u8 {
        let as_u32 = x as u32;
        let as_u16 = as_u32 as u16;
        let as_u8 = as_u16 as u8;
        let back_to_u64 = (as_u8 as u16 as u32) as u64;

        // return as_u8 (smallest) for test purposes
        as_u8
    }
}


//# run 0xCAFE::IntegerOps::example_constants


//# run 0xCAFE::IntegerOps::test_u8 --args 42u8


//# run 0xCAFE::IntegerOps::test_u16 --args 300u16


//# run 0xCAFE::IntegerOps::test_u32 --args 70000u32


//# run 0xCAFE::IntegerOps::test_u64 --args 5000000000u64


//# run 0xCAFE::IntegerOps::test_casting --args 123456789012345u64


// Featurres:
// 92e0070943738d16812fa4208f5a1e8b: Define module constants within a module.
// cf89a2eacbbcaa727a6145ff30969ae7: Write code that uses specific Move syntax tokens, which can be parsed and recognized by the compiler.
// 3bc88f08da8c1fc1b775406d9d65238d: Test that various integer operations—shifts, division, modulo, addition, subtraction, type casting, bitwise AND, OR, XOR—produce the expected results for different unsigned integer types in Move.
