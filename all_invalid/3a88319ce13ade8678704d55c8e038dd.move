
//# publish
module 0xCAFE::ShiftOps {
    // A module to test shift operators including edge cases on all unsigned integer types

    // We define inline functions to test left shifts and right shifts on each unsigned integer type
    // All functions have script visibility so they can be directly invoked by test scripts

//# run
    script fun test_u8_shifts() {
        let x: u8 = 0x1u8;
        let _ = x << 0;   // shift by zero
        let _ = x << 7;   // shift by bit width - 1
        let _ = x << 8;   // shift equals bit width (expect ZERO result in Move semantics)
        let _ = x << 9;   // shift more than bit width
        let _ = x >> 0;
        let _ = 0x80u8 >> 7;
        let _ = 0x80u8 >> 8;
        let _ = 0x80u8 >> 9;
        let _ = 0xFFu8 << 1;
        let _ = 0u8 << 3;
    }

//# run
    script fun test_u16_shifts() {
        let x: u16 = 0x1u16;
        let _ = x << 0;
        let _ = x << 15;
        let _ = x << 16;
        let _ = x << 17;
        let _ = x >> 0;
        let _ = 0x8000u16 >> 15;
        let _ = 0x8000u16 >> 16;
        let _ = 0x8000u16 >> 17;
        let _ = 0xFFFFu16 << 1;
        let _ = 0u16 << 5;
    }

//# run
    script fun test_u32_shifts() {
        let x: u32 = 0x1u32;
        let _ = x << 0;
        let _ = x << 31;
        let _ = x << 32;
        let _ = x << 33;
        let _ = x >> 0;
        let _ = 0x80000000u32 >> 31;
        let _ = 0x80000000u32 >> 32;
        let _ = 0x80000000u32 >> 33;
        let _ = 0xFFFFFFFFu32 << 1;
        let _ = 0u32 << 12;
    }

//# run
    script fun test_u64_shifts() {
        let x: u64 = 0x1u64;
        let _ = x << 0;
        let _ = x << 63;
        let _ = x << 64;
        let _ = x << 65;
        let _ = x >> 0;
        let _ = 0x8000000000000000u64 >> 63;
        let _ = 0x8000000000000000u64 >> 64;
        let _ = 0x8000000000000000u64 >> 65;
        let _ = 0xFFFFFFFFFFFFFFFFu64 << 1;
        let _ = 0u64 << 33;
    }

//# run
    script fun test_u128_shifts() {
        let x: u128 = 0x1u128;
        let _ = x << 0;
        let _ = x << 127;
        let _ = x << 128;
        let _ = x << 129;
        let _ = x >> 0;
        let _ = 0x80000000000000000000000000000000u128 >> 127;
        let _ = 0x80000000000000000000000000000000u128 >> 128;
        let _ = 0x80000000000000000000000000000000u128 >> 129;
        let _ = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128 << 1;
        let _ = 0u128 << 64;
    }

//# run
    script fun test_random_spot_checks() {
        // random checks of expected results
        let x: u8 = 0x12u8;
        let y = x << 3; // 0x12 << 3 = 0x90
        let z = y >> 1; // 0x90 >> 1 = 0x48
        let _ = y;
        let _ = z;
        
        let a: u16 = 0x1234u16;
        let b = a >> 4;  // 0x1234 >> 4 = 0x0123
        let _ = b;

        let c: u32 = 0x12345678u32;
        let d = c << 4;  // 0x12345678 << 4 = 0x23456780
        let _ = d;
    }
}


//# run 0xCAFE::ShiftOps::test_u8_shifts


//# run 0xCAFE::ShiftOps::test_u16_shifts


//# run 0xCAFE::ShiftOps::test_u32_shifts


//# run 0xCAFE::ShiftOps::test_u64_shifts


//# run 0xCAFE::ShiftOps::test_u128_shifts


//# run 0xCAFE::ShiftOps::test_random_spot_checks


// Featurres:
// d2dee3b6c3fd10b775b2a0089f2736ab: Utilize the filtering mechanism to remove specification (spec) blocks associated with module members that have been filtered out of the module.
// 021b4fd0ef730715452d1cd54483dff3: Declare functions or modules that are accessible to scripts using the 'script' visibility modifier, which is treated as public.
// 8ec0236b42fea1a928554f0989660974: Test the correctness and edge-case handling of left and right shift operations (<< and >>) for all unsigned integer types in Move, including shifts by zero, shifts by the bit width and above, overflows, underflows, and random spot checks for expected results.
