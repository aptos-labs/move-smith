//# publish
module 0xabc::OverflowDivisionShiftTest {
    use std::vector;

    // Helper functions to sum vectors, similar to the example but not directly copying
    fun sum_u8(v: &vector<u8>): u8 {
        let total: u8 = 0;
        vector::for_each_ref(v, |elt| total = total + *elt);
        total
    }

    fun sum_u16(v: &vector<u16>): u16 {
        let total: u16 = 0;
        vector::for_each_ref(v, |elt| total = total + *elt);
        total
    }

    fun sum_u32(v: &vector<u32>): u32 {
        let total: u32 = 0;
        vector::for_each_ref(v, |elt| total = total + *elt);
        total
    }

    fun sum_u64(v: &vector<u64>): u64 {
        let total: u64 = 0;
        vector::for_each_ref(v, |elt| total = total + *elt);
        total
    }

    fun sum_u128(v: &vector<u128>): u128 {
        let total: u128 = 0;
        vector::for_each_ref(v, |elt| total = total + *elt);
        total
    }

    fun sum_u256(v: &vector<u256>): u256 {
        let total: u256 = 0;
        vector::for_each_ref(v, |elt| total = total + *elt);
        total
    }

    public fun main() {
        // Vector elements designed to trigger overflow, division by zero, out-of-range shifts
        let fail_u8 = vector<u8>[
            1 << 8,      // shift overflow for u8
            0 >> 8,      // shift beyond u8 bounds
            1 / 0,       // division by zero
            1 % 0,       // modulo by zero
            255 + 255,   // addition overflow for u8
            0 - 1,       // underflow for u8
            ((256: u64) as u8), // cast that overflows
        ];
        let fail_u16 = vector<u16>[
            1 << 16,
            0 >> 16,
            1 / 0,
            1 % 0,
            65535 + 65535,
            0 - 1,
            ((65536: u64) as u16),
        ];
        let fail_u32 = vector<u32>[
            1 << 32,
            (1u8 << 8 as u32),
            ((1u16 << 16) as u32),
            0 >> 32,
            ((0u8 >> 8) as u32),
            ((0u16 >> 16) as u32),
            1 / 0,
            1 % 0,
            4294967295 + 4294967295,
            ((65535u16 + 65535) as u32),
            ((65535 + 65535u16) as u32),
            ((65535u16 + 65535u16) as u32),
            0 - 1,
            ((4294967296: u128) as u32),
        ];
        let fail_u64 = vector<u64>[
            1 << 64,      // shift overflow
            ((1u32 << 32) as u64),
            0 >> 64,
            ((0u32 >> 32) as u64),
            1 / 0,
            1 % 0,
            18446744073709551615 + 18446744073709551615,
            ((255u8 + 255) as u64),
            ((255 + 255u8) as u64),
            ((255u8 + 255u8) as u64),
            ((4294967295u32 + 4294967295) as u64),
            ((4294967295 + 4294967295u32) as u64),
            ((4294967295u32 + 4294967295u32) as u64),
            0 - 1,
            ((340282366920938463463374607431768211450: u128) as u64),
        ];
        let fail_u128 = vector<u128>[
            1 << 128,
            ((1u64 << 64) as u128),
            0 >> 128,
            ((0u64 >> 64) as u128),
            1 / 0,
            1 % 0,
            340282366920938463463374607431768211450 + 340282366920938463463374607431768211450,
            ((18446744073709551615u64 + 18446744073709551615) as u128),
            ((18446744073709551615 + 18446744073709551615u64) as u128),
            ((18446744073709551615u64 + 18446744073709551615u64) as u128),
            0 - 1,
            ((340282366920938463463374607431768211456: u256) as u128),
        ];
        let fail_u256 = vector<u256>[
            ((1u128 << 128) as u256),
            ((0u128 >> 128) as u256),
            1 / 0,
            1 % 0,
            115792089237316195423570985008687907853269984665640564039457584007913129639935 + 115792089237316195423570985008687907853269984665640564039457584007913129639935,
            ((340282366920938463463374607431768211450u128 + 340282366920938463463374607431768211450) as u256),
            ((340282366920938463463374607431768211450 + 340282366920938463463374607431768211450u128) as u256),
            ((340282366920938463463374607431768211450u128 + 340282366920938463463374607431768211450u128) as u256),
            0 - 1,
        ];

        // Invoke sum functions to execute all, expecting some aborts due to invalid operations
        // Note: For testing purposes, actual assertions are omitted, focus is on execution
        let _ = sum_u8(&fail_u8);
        let _ = sum_u16(&fail_u16);
        let _ = sum_u32(&fail_u32);
        let _ = sum_u64(&fail_u64);
        let _ = sum_u128(&fail_u128);
        let _ = sum_u256(&fail_u256);
    }
}

//# run 0xabc::OverflowDivisionShiftTest::main


//# publish
module 0xdef::FunctionPointerInteraction {
    // Inline function that calls a passed-in function pointer with multiple args
    inline fun invoke_g(g: |u64, u64, u64, u64| u64, x: u64, y: u64, z: u64, q: u64): u64 {
        g(x, y, z, q)
    }

    // Function that takes multiple arguments and returns their sum
    fun sum_all(a: u64, b: u64, c: u64, d: u64): u64 {
        a + b + c + d
    }

    public fun test() {
        let result = invoke_g(|a: u64, b: u64, c: u64, d: u64| sum_all(a, b, c, d), 
                               5, 10, 20, 30);
        // For test, no assertions needed; just ensure no aborts and correct interaction
        assert!(result == 65, 0);
    }
}

//# run 0xdef::FunctionPointerInteraction::test