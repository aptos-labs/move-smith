
//# publish
module 0xCAFE::ConstAndOps {
    const CONST_U8: u8 = 42u8;
    const CONST_U16: u16 = 1024u16;
    const CONST_U32: u32 = 0xFFFF_FFFFu32;
    const CONST_U64: u64 = 1_000_000u64;

    public fun use_constants(): u64 {
        let a = CONST_U8 as u64;
        let b = CONST_U16 as u64;
        let c = CONST_U32 as u64;
        let d = CONST_U64;
        a + b + c + d
    }

    public fun test_shift_div_mod(x: u32): (u32, u32, u32) {
        let shl = x << 2;
        let shr = x >> 1;
        let div = x / 3;
        let modu = x % 5;
        (shl, shr, modu + div)
    }

    public fun test_bitwise_ops(a: u8, b: u8): (u8, u8, u8) {
        let and = a & b;
        let or = a | b;
        let xor = a ^ b;
        (and, or, xor)
    }

    public fun safe_cast_u64_to_u16(val: u64): u16 {
        if (val > 65535) {
            65535
        } else {
            val as u16
        }
    }

    public fun test_cast_and_sub(u64_val: u64): u16 {
        let casted = safe_cast_u64_to_u16(u64_val);
        // Check for underflow before subtracting
        assert!(casted >= 1, 1);
        let sub = casted - 1u16;
        sub
    }
}




//# run 0xCAFE::ConstAndOps::use_constants




//# run 0xCAFE::ConstAndOps::test_shift_div_mod --args 25u32




//# run 0xCAFE::ConstAndOps::test_bitwise_ops --args 0xF0u8 0x0Fu8




//# run 0xCAFE::ConstAndOps::test_cast_and_sub --args 70000u64
