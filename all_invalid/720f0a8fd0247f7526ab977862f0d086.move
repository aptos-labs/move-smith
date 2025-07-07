// Feature 1: Diagnostic Secondary Label for '<' Operator Ambiguity

//# publish
module 0xA11CE::DiagnosticExample {
    fun foo(x: u64): u64 {
        // Intentional ambiguous usage for diagnostic: array access vs. operator
        // The compiler should suggest inserting a blank space before '<'
        let arr = vector[1u64, 2u64, 3u64];
        // The line below should trigger a diagnostic that suggests: 
        // Did you mean 'arr < x' or 'arr< x'... ?
        // Here we use: arr<x (no space)
        arr<x
    }
}

// Feature 2: Integer, Boolean, Byte, Hex, Shift, Arithmetic, Logical, Bitwise Operations

//# publish
module 0xBEEF::OpsTest {
    public fun runner() {
        let a_u8 = 15u8;
        let b_u8 = 240u8;
        let a_u64 = 0x10u64; // 16
        let b_u64 = 0b1010u64; // 10
        
        // Arithmetic
        let _add = a_u8 + 2u8;
        let _sub = b_u8 - 120u8;
        let _mul = a_u64 * 2u64;
        let _div = b_u64 / 2u64;
        let _mod = b_u8 % 7u8;
        // Bitwise
        let _bitand = a_u8 & b_u8;
        let _bitor = a_u8 | b_u8;
        let _bitxor = a_u8 ^ b_u8;
        // Shifts
        let _shl = b_u8 << 2;
        let _shr = b_u8 >> 3;
        // Logical and Comparisons
        let t = true;
        let f = false;
        let _and = t && f;
        let _or = t || f;
        let _eq = a_u8 == 15u8;
        let _neq = b_u8 != 241u8;
        let _lt = a_u8 < b_u8;
        let _le = a_u64 <= b_u64;
        let _gt = a_u64 > b_u64;
        let _ge = b_u8 >= 100u8;
        // Hex, Bytes
        let _hex = 0xEFu8;
        let _byte = 255u8;
        // No asserts, just assignments to exercise the VM.
    }
}
//# run 0xBEEF::OpsTest::runner --signers 0xCAFE

// Feature 3: Address Literal Expressions

//# publish
module 0xDEAD::AddrLiterals {
    use std::vector;

    public fun runner() {
        let add1 = @0x1;
        let add2 = @0xDEADBEEF;
        let add3 = @0xA11CE;
        
        // Address comparison and equality
        let _eq = add1 == @0x1;
        let _neq = add2 != @0xCAFE;
        // Address vector operations
        let addrs = vector::empty<address>();
        vector::push_back(&mut addrs, add1);
        vector::push_back(&mut addrs, @0xCAFE);
        let _fetched = *vector::borrow(&addrs, 1);
    }
}
//# run 0xDEAD::AddrLiterals::runner --signers 0xDEAD