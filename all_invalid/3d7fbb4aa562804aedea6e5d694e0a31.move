//# publish
module 0xCAFE::NestedPatternsAndInvariants {
    use std::vector;
    use std::signer;

    struct Inner has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        x: u16,
        y: u16,
        flag: bool,
    }

    enum MyEnum has copy, drop {
        Variant1,
        Variant2(u8, u8, u8, u8),          // 4 tuple fields
        Variant3 { p: u8, q: u8, r: u8 },  // 3 named fields
    }

    // Function demonstrating dotted expressions to access nested fields
    public fun access_nested_fields(o: &Outer): (u8, u8, u16, bool) {
        let a = o.inner.a;
        let b = o.inner.b;
        let x = o.x;
        let flag = o.flag;
        (a, b, x, flag)
    }

    // Function demonstrating positional unpacking of struct with `..` skipping fields
    public fun pos_unpack_outer(o: Outer): u8 {
        let Outer { inner: Inner {a, ..}, .. } = o;
        a
    }

    // Function demonstrating positional unpacking of enum variant with .. ignoring trailing fields
    public fun pos_unpack_enum(e: MyEnum): u8 {
        let MyEnum::Variant2(a, b, ..) = e;
        // returns sum of first two fields
        a + b
    }

    // Function that uses dotted expressions with enum pattern unpacking
    public fun unpack_and_access(e: MyEnum): u8 {
        let MyEnum::Variant3 { p, .. } = e;
        p
    }

    // Function with a loop and loop invariant in spec block inside Move code
    public fun sum_loop(n: u8): u64 {
        let mut i = 0u8;
        let mut sum = 0u64;
        while (i < n) {
            sum = sum + (i as u64);
            i = i + 1;
        };
        sum
    }
    
    spec sum_loop {
        // Loop invariant: sum == i*(i-1)/2 (sum of 0..i-1)
        // Constraints cannot use operators like / or * easily,
        // so let's express an equivalent simpler invariant:
        // For all iteration: sum == (i*(i-1))/2, i <= n

        // Use the has_spec pragma to bind vars for the loop invariant
        pragma(invariant: "let lhs = sum * 2; let rhs = (i as u64) * ((i as u64) - 1); lhs == rhs");
        pragma(invariant: "i <= (n as u8)");
    }

}

//# run 0xCAFE::NestedPatternsAndInvariants::access_nested_fields --args 0xCAFE::NestedPatternsAndInvariants::Outer { inner: 0xCAFE::NestedPatternsAndInvariants::Inner { a: 1u8, b: 2u8, c: 3u8 }, x: 100u16, y: 200u16, flag: true }

//# run 0xCAFE::NestedPatternsAndInvariants::pos_unpack_outer --args 0xCAFE::NestedPatternsAndInvariants::Outer { inner: 0xCAFE::NestedPatternsAndInvariants::Inner { a: 9u8, b: 8u8, c: 7u8 }, x: 20u16, y: 30u16, flag: false }

//# run 0xCAFE::NestedPatternsAndInvariants::pos_unpack_enum --args 0xCAFE::NestedPatternsAndInvariants::MyEnum::Variant2(5u8, 10u8, 20u8, 40u8)

//# run 0xCAFE::NestedPatternsAndInvariants::unpack_and_access --args 0xCAFE::NestedPatternsAndInvariants::MyEnum::Variant3 { p: 42u8, q: 43u8, r: 44u8 }

//# run 0xCAFE::NestedPatternsAndInvariants::sum_loop --args 10u8

// Featurres:
// b8d7a7a1d55c34effe5462a58911f6b0: Use dotted expressions to access nested fields or members in Move code.
// 99e0c7dc69100368ea067e3fb522be33: Perform positional unpacking of struct or variant patterns with support for a single `..` to ignore remaining fields.
// 4b11123d344e171b852c0c964e14cdb2: Use loop invariants in spec blocks inside Move code to specify properties that should hold true across loop iterations
