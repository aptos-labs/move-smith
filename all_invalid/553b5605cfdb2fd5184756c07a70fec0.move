//# publish
module 0xCAFE::BitwiseTest {
    use std::debug;

    // Singleton layout struct (record-like)
    struct Single has copy, drop, store {
        val: u8,
    }

    // Struct with multiple fields to test unpacking syntax
    struct Multi has copy, drop, store {
        a: u64,
        b: u8,
        c: bool,
    }

    // Enum with multiple variants and fields to test variant unpacking
    enum BitEnum has copy, drop {
        None,
        ValU8(u8),
        ValU64 { val: u64 },
        FlagSet { enabled: bool, count: u8 },
    }

    /// Helper to unpack struct Multi fields with braces pattern
    public fun unpack_multi(m: Multi): (u64, u8, bool) {
        let Multi { a, b, c } = m;
        (a, b, c)
    }

    /// Helper to unpack enum BitEnum variants with braces and tuple syntax
    public fun unpack_enum(e: BitEnum): u64 {
        match e {
            BitEnum::None => 0,
            BitEnum::ValU8(x) => x as u64,
            BitEnum::ValU64 { val } => val,
            BitEnum::FlagSet { enabled, count } =>
                if (enabled) { count as u64 } else { 0 },
        }
    }

    /// Left shift for u8 with various checks
    public fun test_shift_u8(): bool {
        // Shift by 0
        let a = 0x12u8 << 0;
        // Shift by within bound
        let b = 0x01u8 << 3; // expect 8
        // Shift by bit width 8 (all bits shifted out => 0)
        let c = 0xFFu8 << 8;
        // Shift by above bit width (e.g. 12)
        let d = 0x80u8 << 12;
        // Overflow check: shifting 1 into high bit
        let e = 1u8 << 7; // 128
        (a == 0x12) && (b == 8) && (c == 0) && (d == 0) && (e == 128)
    }

    /// Right shift for u8 with various checks
    public fun test_rshift_u8(): bool {
        let a = 0x12u8 >> 0;
        let b = 0x80u8 >> 7; // expect 1
        let c = 0xFFu8 >> 8; // expect 0
        let d = 0xF0u8 >> 12; // expect 0
        let e = 0x04u8 >> 2; // expect 1
        (a == 0x12) && (b == 1) && (c == 0) && (d == 0) && (e == 1)
    }

    /// Generic function to test left shift edge cases for all unsigned types
    public fun test_left_shifts() {
        // u8
        assert!(test_shift_u8(), 1001);

        // u16
        let x16 = 0x1000u16;
        let y1 = x16 << 0;
        let y2 = 1u16 << 15;
        let y3 = 0xFFFFu16 << 16;
        assert!(y1 == x16, 1002);
        assert!(y2 == 0x8000, 1003);
        assert!(y3 == 0, 1004);

        // u32
        let x32 = 0x40000000u32;
        let z1 = x32 << 0;
        let z2 = 1u32 << 31;
        let z3 = 0xFFFFFFFFu32 << 32;
        assert!(z1 == x32, 1005);
        assert!(z2 == 0x80000000, 1006);
        assert!(z3 == 0, 1007);

        // u64
        let x64 = 0x1000000000000000u64;
        let w1 = x64 << 0;
        let w2 = 1u64 << 63;
        let w3 = 0xFFFFFFFFFFFFFFFFu64 << 64;
        assert!(w1 == x64, 1008);
        assert!(w2 == 0x8000000000000000, 1009);
        assert!(w3 == 0, 1010);

        // u128
        let maxu128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let v1 = 1u128 << 127;
        let v2 = maxu128 << 128;
        assert!(v1 == 0x80000000000000000000000000000000, 1011);
        assert!(v2 == 0, 1012);
    }

    /// Generic function to test right shift edge cases for all unsigned types
    public fun test_right_shifts() {
        // u8
        assert!(test_rshift_u8(), 2001);

        // u16
        let a16 = 0x8000u16;
        let b1 = a16 >> 0;
        let b2 = 0x8000u16 >> 15;
        let b3 = 0xFFFFu16 >> 16;
        assert!(b1 == a16, 2002);
        assert!(b2 == 1, 2003);
        assert!(b3 == 0, 2004);

        // u32
        let a32 = 0x80000000u32;
        let c1 = a32 >> 0;
        let c2 = 0x80000000u32 >> 31;
        let c3 = 0xFFFFFFFFu32 >> 32;
        assert!(c1 == a32, 2005);
        assert!(c2 == 1, 2006);
        assert!(c3 == 0, 2007);

        // u64
        let a64 = 0x8000000000000000u64;
        let d1 = a64 >> 0;
        let d2 = 0x8000000000000000u64 >> 63;
        let d3 = 0xFFFFFFFFFFFFFFFFu64 >> 64;
        assert!(d1 == a64, 2008);
        assert!(d2 == 1, 2009);
        assert!(d3 == 0, 2010);

        // u128
        let a128 = 0x80000000000000000000000000000000u128;
        let e1 = a128 >> 0;
        let e2 = a128 >> 127;
        let e3 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128 >> 128;
        assert!(e1 == a128, 2011);
        assert!(e2 == 1, 2012);
        assert!(e3 == 0, 2013);
    }

    public fun runner() {
        // Produce a Multi struct and test unpacking
        let m = Multi { a: 123u64, b: 45u8, c: true };
        let (a, b, c) = unpack_multi(m);
        // Call debug to see fields (just for test, no assertion)
        debug::print(&a);
        debug::print(&b);
        debug::print(&c);

        // Produce enum variants and unpack
        let v1 = BitEnum::None;
        let v2 = BitEnum::ValU8(55u8);
        let v3 = BitEnum::ValU64 { val: 9999u64 };
        let v4 = BitEnum::FlagSet { enabled: true, count: 7u8 };

        let _ = unpack_enum(v1);
        let _ = unpack_enum(v2);
        let _ = unpack_enum(v3);
        let _ = unpack_enum(v4);

        test_left_shifts();
        test_right_shifts();
    }
}

//# run 0xCAFE::BitwiseTest::runner

// Featurres:
// dd32a0d7b93b89cb4cc9253a0257c0d1: Use unpacking syntax for struct or variant field access with braces
// ea2e53c49b97770577bf263fb135e66e: Define structs with singleton (record-like) layouts in your modules
// 8ec0236b42fea1a928554f0989660974: Test the correctness and edge-case handling of left and right shift operations (<< and >>) for all unsigned integer types in Move, including shifts by zero, shifts by the bit width and above, overflows, underflows, and random spot checks for expected results.
