
//# publish
module 0xCAFE::NestedMatchTest {
    // Nested enums with variants that include named fields and tuples
    enum InnerEnum has copy, drop {
        A,
        B(u8),
        C { flag: bool, val: u8 }
    }

    enum OuterEnum has copy, drop {
        X(InnerEnum),
        Y { inner: InnerEnum, id: u64 },
        Z
    }

    // Inline function with parameters to test parameter usage checking
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // A function testing nested pattern matching with guards and wildcards
    public fun complex_match(e: OuterEnum): u8 {
        let res = match (e) {
            OuterEnum::X(InnerEnum::A) => 1,
            OuterEnum::X(InnerEnum::B(val)) if (val < 10) => val,
            OuterEnum::X(InnerEnum::B(_)) => 100,
            OuterEnum::X(InnerEnum::C { flag, val }) if (flag) => val * 2,
            OuterEnum::X(InnerEnum::C { flag: false, val: _ }) => 0,

            OuterEnum::Y { inner, id } if (id == 0) => {
                match (inner) {
                    InnerEnum::A => 10,
                    InnerEnum::B(v) => v + 10,
                    InnerEnum::C { flag, val } if (flag) => val + 20,
                    InnerEnum::C { flag: false, val: _ } => 10,
                }
            },

            OuterEnum::Y { inner: _, id } if (id > 100) => 255,

            OuterEnum::Z => 42,

            // Wildcard case should be unreachable if all cases are handled
            _ => 0,
        };
        res
    }

    // Runner function for above test with various inputs to exercise all paths
    public fun test_runner(): () {
        let r1 = complex_match(OuterEnum::X(InnerEnum::A));
        let r2 = complex_match(OuterEnum::X(InnerEnum::B(5)));
        let r3 = complex_match(OuterEnum::X(InnerEnum::B(15)));
        let r4 = complex_match(OuterEnum::X(InnerEnum::C { flag: true, val: 7 }));
        let r5 = complex_match(OuterEnum::X(InnerEnum::C { flag: false, val: 8 }));

        let r6 = complex_match(OuterEnum::Y { inner: InnerEnum::A, id: 0 });
        let r7 = complex_match(OuterEnum::Y { inner: InnerEnum::B(3), id: 0 });
        let r8 = complex_match(OuterEnum::Y { inner: InnerEnum::C { flag: true, val: 4 }, id: 0 });
        let r9 = complex_match(OuterEnum::Y { inner: InnerEnum::C { flag: false, val: 5 }, id: 0 });

        let r10 = complex_match(OuterEnum::Y { inner: InnerEnum::A, id: 150 });
        let r11 = complex_match(OuterEnum::Z);

        // Test inline function with unused parameter check by calling it
        let _ = inline_add(10, 20);
    }
}


//# run 0xCAFE::NestedMatchTest::test_runner


// Featurres:
// b5aba08f0fb25e75add39c5048f6f4dc: Ensure that pattern matching over nested enums, including variants with named fields, wildcards, and guards, correctly handles all cases, including complex nested destructuring and unreachable code detection.
// 057ed43b704e6042288e427679b31ffe: Ensure inline functions have their parameters properly checked for usage.
// e046b2e91b3910c3dd96eb1be778c6ca: Use 'if' guard conditions in match arms to add conditional logic to pattern matching.
