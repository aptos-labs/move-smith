//# publish
module 0xCAFE::GenericStructEnum {

    // Struct with type parameters S, T, U
    struct Pair<S, T> has copy, drop, store, key {
        first: S,
        second: T,
    }

    struct Triple<X, Y, Z> has copy, drop, store {
        val1: X,
        val2: Y,
        val3: Z,
    }

    // Enum with generic parameter A
    enum MyEnum<A> has copy, drop, store {
        VariantOne(A),
        VariantTwo { x: u64, y: A },
        VariantThree,
    }

    // Nested enum with two type params
    enum NestedEnum<P, Q> has copy, drop, store {
        NestedVariantOne { p: P, q: Q },
        NestedVariantTwo(Triple<P, Q, u8>),
    }

    // A struct that refers to another generic struct inside
    struct Container<T> has copy, drop, store, key {
        content: Pair<T, NestedEnum<u8, T>>,
    }

    // function to create a Pair<u8, bool> to test simple instantiation
    public fun make_pair_simple(): Pair<u8, bool> {
        Pair { first: 5u8, second: true }
    }

    // function to create a Triple<u64, bool, u8> to test nested generics
    public fun make_triple(): Triple<u64, bool, u8> {
        Triple { val1: 123u64, val2: false, val3: 42u8 }
    }

    // function to create a MyEnum<u64> variant with struct variant
    public fun make_my_enum_var2(): MyEnum<u64> {
        MyEnum::VariantTwo { x: 999u64, y: 777u64 }
    }

    // function to create NestedEnum<u8, u64> VariantTwo with nested Triple
    public fun make_nested_enum(): NestedEnum<u8, u64> {
        let triple = Triple { val1: 1u8, val2: 2u64, val3: 3u8 };
        NestedEnum::NestedVariantTwo(triple)
    }

    // Runner function to test complex pattern matching on enums and structs
    public fun runner() {
        // unpack Pair<u8, bool>
        let pair = make_pair_simple();
        let Pair { first: a, second: b } = pair;
        // NOTE: no assertions, just pattern matching

        // Nested pattern matching with Triple<u64, bool, u8>
        let triple = make_triple();
        let Triple { val1: v1, val2: v2, val3: v3 } = triple;

        // Pattern match MyEnum<u64> VariantTwo
        let me = make_my_enum_var2();
        if (true) {
            match me {
                MyEnum::VariantOne(_) => {},
                MyEnum::VariantTwo { x, y } => { let _ = x + y; },
                MyEnum::VariantThree => {},
            }
        }

        // Match NestedEnum<u8, u64>
        let ne = make_nested_enum();
        if (true) {
            match ne {
                NestedEnum::NestedVariantOne { p, q } => { let _ = p + (q as u8); },
                NestedEnum::NestedVariantTwo(triple) => {
                    // triple here is Triple<u8, u64, u8>
                    let Triple { val1, val2, val3 } = triple;
                    let _ = val1 + (val2 as u8) + val3;
                },
            }
        }

        // Use wildcard pattern and conditional guard
        let me2 = MyEnum::VariantOne(42u64);
        if (true) {
            match me2 {
                MyEnum::VariantOne(v) if v > 40u64 => {},
                MyEnum::VariantOne(_) => {},
                _ => {},
            }
        }

        // Use reference pattern for Pair
        let pair_ref = &make_pair_simple();
        // Reference pattern in Move is `let &Pair { ... } = ...` (Move supports references pattern)
        let &Pair { first: ref_f, second: ref_s } = pair_ref;
        let _ = *ref_f;
        let _ = *ref_s;

        // Partial pattern with common fields for VariantTwo
        let MyEnum::VariantTwo { x, .. } = make_my_enum_var2();

        // Nested pattern with common fields and wildcard for Triple inside NestedVariantTwo
        let NestedEnum::NestedVariantTwo(Triple { val1, .. }) = make_nested_enum();

        // Pattern match on Container using nested patterns
        let container = Container {
            content: Pair {
                first: 10u8,
                second: NestedEnum::NestedVariantOne { p: 20u8, q: 30u8 }
            }
        };
        let Container { content: Pair { first: cf, second: NestedEnum::NestedVariantOne { p, q } } } = container;
        let _ = cf + p + q;
    }
}

//# run 0xCAFE::GenericStructEnum::runner --signers 0xCAFE