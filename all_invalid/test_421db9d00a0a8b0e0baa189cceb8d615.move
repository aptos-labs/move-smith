//# publish
module 0xABCDEF::primitive_struct_copy_test {
    fun process_u64(val: u64) {
        // A dummy function to consume u64 without side effects
        assert!(val >= 0, 0);
    }

    fun process_struct(s: S) {
        // A dummy function to consume struct without side effects
        assert!(s.a >= 0, 0);
    }

    struct S has copy, drop {
        a: u64,
        b: u64,
    }

    public fun main() {
        let primitive_value: u64 = 42;
        let struct_value = S { a: 10, b: 20 };

        // Copy primitive and pass to function
        let copied_primitive = copy primitive_value;
        process_u64(copied_primitive);
        process_u64(primitive_value);

        // Copy struct and pass
        let copied_struct = copy struct_value;
        process_struct(copied_struct);
        process_struct(struct_value);
    }
}

//# run 0xABCDEF::primitive_struct_copy_test::main

//# publish
module 0xABCDEF::shadowing_variable_names {
    public fun inline_func(f:|u64|, x:u64) {
        f(x);
    }

    public fun inline_func2(f:|u64|, x:u64) {
        let x = x;
        f(x);
    }

    public fun test_shadowing(mut x: u64) {
        // Shadow outer variable x inside closure
        inline_func(|y: u64| {
            // Assign to outer x
            x = y; // Expected to update outer x
        }, 3);
        assert!(x == 3, 0);

        inline_func2(|y: u64| {
            // Assign to outer x
            x = y;
        }, 5);
        assert!(x == 5, 0);
    }

    public fun test_shadowing2(q: u64) {
        let mut x = q;
        inline_func(|y: u64| {
            x = y;
        }, 7);
        assert!(x == 7, 0);

        inline_func2(|y: u64| {
            x = y;
        }, 9);
        assert!(x == 9, 0);
    }

    public fun run_tests() {
        test_shadowing(1);
        test_shadowing2(1);
    }
}

//# run 0xABCDEF::shadowing_variable_names::run_tests

//# publish
module 0x123456::pattern_matching_tests {
    enum ComplexEnum has drop {
        VariantA { a: Q, b: R },
        VariantB { x: u64 },
        VariantC,
    }

    enum Q has drop {
        QX,
        QY,
    }

    enum R has drop {
        R1,
        R2,
    }

    public fun test_match_nested(a: ComplexEnum) {
        match (a) {
            ComplexEnum::VariantA { a: Q::QX, b: R::R1 } => {},
            ComplexEnum::VariantA { a: _, b: R::R2 } => {},
            ComplexEnum::VariantA { a: Q::QY, b: _ } => {},
            _ => {},
        }
    }

    enum DeepEnum has drop {
        D1 { f: F, g: G },
        D2 { h: u64 },
    }

    enum F has drop {
        F1,
        F2 { a: G }
    }

    enum G has drop {
        G1 { p: H, q: H },
        G2 { p: H }
    }

    enum H has drop {
        H1 { a: u64 },
        H2 { b: u64 }
    }

    public fun test_deep_match(e: DeepEnum) {
        match (e) {
            DeepEnum::D1 { f: F::F2 { a: G::G1 { p: H::H1 { a: _ }, q: _ }, .. }, g: _ } => {},
            DeepEnum::D1 { f: F::F1, g: _ } => {},
            DeepEnum::D2 { h: _ } => {},
        }
    }
}

//# run 0x123456::pattern_matching_tests::test_match_nested
//# run 0x123456::pattern_matching_tests::test_deep_match

//# publish
module 0x789abc::nested_enum_mask {
    enum Outer has drop {
        V1 { inner: Inner },
        V2 { inner: Inner },
    }

    enum Inner has drop {
        A { x: u64 },
        B { y: u64 },
    }

    public fun test1(e: Outer) {
        match (e) {
            Outer::V1 { inner: Inner::A { x } } => { /* handle A */ },
            Outer::V2 { inner: Inner::B { y } } => { /* handle B */ },
            _ => {},
        }
    }

    public fun test2(e: Outer) {
        match (e) {
            Outer::V1 { inner: Inner::A { x } } => {},
            Outer::V1 { inner: Inner::B { y } } => {},
            Outer::V2 { inner: Inner::A { x } } => {},
            Outer::V2 { inner: Inner::B { y } } => {},
        }
    }
}

//# run 0x789abc::nested_enum_mask::test1
//# run 0x789abc::nested_enum_mask::test2

//# publish
module 0x555555::complex_enum_unreachable {
    enum RichEnum has drop {
        Variant1 { a: u64 },
        Variant2 { b: u64 },
        Variant3,
    }

    public fun test_unreachable(e: RichEnum) {
        match (e) {
            RichEnum::Variant1 { a } => { /* do something */ },
            RichEnum::Variant2 { b } => { /* do something else */ },
            RichEnum::Variant3 => {
                // Should recognize this is reachable
            },
            // Unreachable arm if pattern matches are exhaustive
        }
    }
}

//# run 0x555555::complex_enum_unreachable::test_unreachable