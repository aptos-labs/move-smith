
//# publish
module 0xCAFE::ComplexBinding {
    struct Inner has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Outer has store {
        inner: Inner,
        x: u8,
    }

    public fun create_outer(): Outer {
        Outer { inner: Inner { a: 1, b: 2 }, x: 3 }
    }

    public fun modify_nested(o: &mut Outer) {
        // Destructure with grouping and commas
        let (inner_ref, x_ref) = (&mut o.inner, &mut o.x);

        // Destructure inner fields
        let (a_ref, b_ref) = (&mut (*inner_ref).a, &mut (*inner_ref).b);

        // Mutate fields through explicit dereferencing
        *a_ref = 10;
        *b_ref = 20;
        *x_ref = 30;
    }

    public fun return_values(o: &Outer): (u8, u8, u8) {
        let (a, b) = (o.inner.a, o.inner.b);
        let x = o.x;
        (a, b, x)
    }

    public fun runner() {
        let outer = create_outer();
        modify_nested(&mut outer);
        let (_a, _b, _x) = return_values(&outer);
    }
}


//# run 0xCAFE::ComplexBinding::runner


//# publish
module 0xCAFE::TestNamedAddresses {
    use 0xCAFE::ComplexBinding;

    public fun call_runner() {
        ComplexBinding::runner();
    }
}


//# run 0xCAFE::TestNamedAddresses::call_runner


// Featurres:
// b7e53f65d437cbb0b2e90ba176221361: Use parentheses and commas to group multiple variables or destructuring patterns in a single binding statement
// fb1e25ca90c27954dba599d551f1cf59: Use named addresses in module references to resolve modules.
// 02fe5431b4d49fb4de6858a4f9c447b2: Test that assignments to complex nested references with explicit dereferencing are correctly handled and update the expected values.
