
//# publish
module 0xCAFE::HexLiteralSpecTest {
    use std::vector;

    // Unsigned integer values with various hex literals including leading zeros
    const U8_VAL1: u8 = 0x01u8;
    const U8_VAL2: u8 = 0x0001u8;
    const U16_VAL1: u16 = 0x0001u16;
    const U16_VAL2: u16 = 0x0A0Bu16;
    const U32_VAL1: u32 = 0x00000001u32;
    const U32_VAL2: u32 = 0x00ABCDEFu32;
    const U64_VAL1: u64 = 0x0000000000000001u64;
    const U64_VAL2: u64 = 0x0123456789ABCDEFu64;
    const U128_VAL1: u128 = 0x00000000000000000000000000000001u128;
    const U128_VAL2: u128 = 0x0F0E0D0C0B0A09080706050403020100u128;

    // largest u256 literal with leading zeros (split for readability, valid hex literal)
    const U256_VAL1: u256 = 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001u256;
    const U256_VAL2: u256 = 0xABCDEF00000000000000000000000000000000000000000000000000000000u256;

    // Spec functions with explicitly declared return types using colon syntax
    spec fun return_u8(): u8 {
        0x01u8
    }

    spec fun return_u16(): u16 {
        0x000Au16
    }

    spec fun return_u32(): u32 {
        0x0000_0001u32
    }

    spec fun return_u64(): u64 {
        0x0000_0000_0000_0001u64
    }

    spec fun return_u128(): u128 {
        0x00000000000000000000000000000001u128
    }

    spec fun return_u256(): u256 {
        0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001u256
    }

    // Spec generic function with explicit return type
    spec fun generic_identity<T: copy> (x: T): T {
        x
    }

    // Invariant using generic type T and unsigned literals
    invariant [T: copy] {
        forall (v: T) {
            true
        }
    }

    // Invariant update using generic type T
    spec update_invariant<T: copy> () {
        // dummy spec update, just to verify syntax; no op
    }

    // Axiom with generic type T and unsigned literals
    axiom [T: copy] {
        forall (a: T, b: T) {
            true
        }
    }

    // Spec const use inside an invariant (dummy)
    const SPEC_CONST: u8 = 0xABu8;

    invariant {
        SPEC_CONST == 0xABu8
    }

    // Runner function to use all unsigned literals in Move code so they're tested in VM/compile time too
    public fun run_literals_usage(): (u8, u16, u32, u64, u128, u256) {
        let _a = U8_VAL1 + 0u8;
        let _b = U8_VAL2 + 0u8;
        let _c = U16_VAL1 + 0u16;
        let _d = U16_VAL2 + 0u16;
        let _e = U32_VAL1 + 0u32;
        let _f = U32_VAL2 + 0u32;
        let _g = U64_VAL1 + 0u64;
        let _h = U64_VAL2 + 0u64;
        let _i = U128_VAL1 + 0u128;
        let _j = U128_VAL2 + 0u128;
        let _k = U256_VAL1 + 0u256;
        let _l = U256_VAL2 + 0u256;

        // Return sum of some literals casted as u8 for a simple result
        (U8_VAL1, U16_VAL1, U32_VAL1, U64_VAL1, U128_VAL1, U256_VAL1)
    }
}


//# run 0xCAFE::HexLiteralSpecTest::run_literals_usage


// Featurres:
// 5baab59f411599ad0a4ff7f948d44fc8: Test that unsigned integer literals correctly interpret various hexadecimal representations with leading zeros across multiple integer sizes.
// ba65b0a21cd5b5515b25dcf742939b68: Specify the return type of a spec function after a colon.
// d867c79eed0d8c484a5f63e5307fbdea: Declare invariants, invariant updates, and axioms with type parameters in Move specifications.
