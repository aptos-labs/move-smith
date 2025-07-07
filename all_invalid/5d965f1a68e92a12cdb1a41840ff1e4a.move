//# publish
module 0xCAFE::PositionalAndVariants {
    use std::vector;

    struct Point has copy, drop, store {
        0: u64,
        1: u64,
    }

    enum Color has copy, drop {
        Red,
        Green(u8),
        Blue { 0: bool, 1: u8 },
    }

    public fun create_point_and_add(x: u64, y: u64): u64 {
        let p = Point { 0: x, 1: y };
        let sum = p.0 + p.1;
        sum
    }

    public fun test_variants() {
        let c1 = Color::Red;
        let c2 = Color::Green(42u8);
        let c3 = Color::Blue { 0: true, 1: 7u8 };

        let value = match (c1) {
            Color::Red => 1u8,
            Color::Green(x) => x,
            Color::Blue { 0: b1, 1: b2 } => if (b1) { b2 } else { 0u8 },
        };

        let value2 = match (c2) {
            Color::Red => 1u8,
            Color::Green(x) => x,
            Color::Blue { 0: b1, 1: b2 } => if (b1) { b2 } else { 0u8 },
        };

        let value3 = match (c3) {
            Color::Red => 1u8,
            Color::Green(x) => x,
            Color::Blue { 0: b1, 1: b2 } => if (b1) { b2 } else { 0u8 },
        };

        let _ = value + value2 + value3;
    }

    public fun arithmetic_test(a: u8, b: u8): u8 {
        let c = a + b;
        let d = c * 2;
        let e = d / 3;
        e
    }
}

//# run 0xCAFE::PositionalAndVariants::create_point_and_add --args 10u64 20u64

//# run 0xCAFE::PositionalAndVariants::test_variants

//# run 0xCAFE::PositionalAndVariants::arithmetic_test --args 7u8 8u8

// Featurres:
// fb945d0ba577a3bb19b24dce900e88ac: Use positional fields represented by numeric literals (`0`, `1`, etc.) in your Move code when referring to positional data.
// 7f5f485a46e2de7bb31ad797f6d00c23: Test that local variable declarations and arithmetic expressions execute without errors in a Move function.
// dff165b90d81be268aa2dd6355fb7b75: Perform variant testing (`test_variants`) on enum types only within the module that defines the enum.
