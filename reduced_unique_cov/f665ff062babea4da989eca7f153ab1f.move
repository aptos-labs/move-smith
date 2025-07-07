
//# publish
module 0xCAFE::ComplexTest {
    use std::signer;

    struct Inner has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        c: u8,
    }

    public fun add_and_return_target(x: u8, y: u8): u8 {
        let sum = x + y;
        let target = 42u8;
        let _ = sum; // compute sum but return fixed value
        target
    }

    public fun lambda_test(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v + 10
        };
        lambda(x)
    }

    public fun nested_field_access(): u8 {
        let inner = Inner { a: 1, b: 2 };
        let outer = Outer { inner, c: 3 };
        // multiple dot operators: access Outer.inner.a and Outer.inner.b
        let total = outer.inner.a + outer.inner.b + outer.c;
        total
    }

    public fun tuple_pattern_binding(): (u8, u8, u8) {
        let (p, q, r) = (10u8, 20u8, 30u8);
        (p, q, r)
    }

    public fun nested_tuple_binding(): (u8, u8) {
        let ((a, b), c) = ((1u8, 2u8), 3u8);
        (a + b, c)
    }

    public fun combined_test(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            let (m, n) = (p + 1, q + 2);
            m + n
        };
        f(x, y)
    }

    public fun runner() {
        // call all above to exercise them, no return values needed
        let _ = add_and_return_target(5u8, 7u8);
        let _ = lambda_test(11u8);
        let _ = nested_field_access();
        let (_a, _b, _c) = tuple_pattern_binding();
        let (_x, _y) = nested_tuple_binding();
        let _ = combined_test(4u8, 5u8);
    }
}


//# run 0xCAFE::ComplexTest::add_and_return_target --args 1u8 2u8


//# run 0xCAFE::ComplexTest::lambda_test --args 7u8


//# run 0xCAFE::ComplexTest::nested_field_access


//# run 0xCAFE::ComplexTest::tuple_pattern_binding


//# run 0xCAFE::ComplexTest::nested_tuple_binding


//# run 0xCAFE::ComplexTest::combined_test --args 3u8 4u8


//# run 0xCAFE::ComplexTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 144d392878d634a9938c334f29348413: Nest field access expressions using multiple dot operators
// 0558b20660f8fa1a390bc24f4c693d3d: Bind multiple variables using tuple patterns or similar 'lvalue' syntax in assignment or let statements
