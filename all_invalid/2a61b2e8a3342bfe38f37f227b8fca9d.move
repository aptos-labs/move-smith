// Feature 1: Test that a 33-byte vector with high bit set (0x80) is considered equal to its hexadecimal representation

//# publish
module 0xA1::VecEq {
    use std::vector;
    use std::debug;
    use std::signer;

    // Feature 2: Define constants
    const HIGH_BIT: u8 = 0x80;
    const LEN: u8 = 33;

    // A constant 33-byte vector with 0x80 at position 0, rest zeros
    const VECTOR_CONST: vector<u8> = b"\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";

    public fun runner(signer: &signer) {
        let v1 = vector::empty<u8>();
        let i = 0;
        while (i < LEN) {
            vector::push_back<u8>(&mut v1, if i == 0 { HIGH_BIT } else { 0u8 });
            i = i + 1;
        };
        let v2 = b"\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
        let v3 = VECTOR_CONST;
        debug::print(&v1);
        debug::print(&v2);
        debug::print(&v3);
        // Test equality
        if (!vector::equals<u8>(&v1, &v2)) {
            debug::print<u8>(&[9u8]);
        };
        if (!vector::equals<u8>(&v1, &v3)) {
            debug::print<u8>(&[8u8]);
        };
        if (!vector::equals<u8>(&v2, &v3)) {
            debug::print<u8>(&[7u8]);
        };
    }
}
//# run 0xA1::VecEq::runner --signers 0xA1

// Feature 2+3: Constants and nested local variable blocks
//# publish
module 0xB1::ConstAndBlock {
    use std::debug;
    use std::signer;

    const C1: u64 = 1234;
    const C2: u64 = 5678;

    // Test local updates in nested blocks, sum updated values
    public fun runner(_: &signer) {
        let x = C1;
        let y = C2;
        {
            let x = x + 1;
            {
                let y = y + 2;
                let z = x + y;
                debug::print(&z); // Should print (C1+1) + (C2+2)
            };
            let z2 = x + y;
            debug::print(&z2); // x+C2 since y shadows only in inner
        };
        let total = x + y;
        debug::print(&total); // C1+C2
    }
}
//# run 0xB1::ConstAndBlock::runner --signers 0xB1