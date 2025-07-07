
//# publish
module 0xCAFE::CastAndEnumTest {
    struct Dummy has store {}

    enum Color has copy, drop, store {
        Red,
        Green(u8),
        Blue { intensity: u8 }
    }

    public fun cast_example(val: u8): u16 {
        let res = (val as u16);
        res
    }

    public fun create_colors(): Color {
        let c1 = Color::Red;
        let c2 = Color::Green(42);
        let c3 = Color::Blue { intensity: 255 };
        // To make sure compiler creates stackless bytecode for enum variant constructions.
        c3
    }

    public fun match_enum(c: Color): u8 {
        let result = match (c) {
            Color::Red => 1,
            Color::Green(v) => v,
            Color::Blue { intensity } => intensity,
        };
        result
    }
}


//# run 0xCAFE::CastAndEnumTest::cast_example --args 100u8


//# run 0xCAFE::CastAndEnumTest::create_colors


//# run 0xCAFE::CastAndEnumTest::match_enum --args 0xCAFE::CastAndEnumTest::Color::Green(77u8)


// Featurres:
// a01eac4a9de274c6bfd38c12b8d00ebc: Generate stackless bytecode for each public (non-inline) function defined in target modules
// 2461d5aa9c9cdc3bef5fae8844912c5a: Cast expressions to a specified type using the 'as' keyword (e as Type).
// eec4b5db199960ba48877cef2c2f302e: Declare enums with multiple variants.
