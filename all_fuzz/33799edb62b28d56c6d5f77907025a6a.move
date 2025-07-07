
//# publish
module 0xCAFE::TestLambdaAndInline {
    use std::vector;

    public fun add_u8_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;

        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + 10u8
        };
        // call the lambda with sum
        lambda(sum)
    }

    public inline fun increment_and_double(x: u8): (u8, u8) {
        (x + 1, x * 2)
    }

    public fun use_inline_and_lambda(x: u8): u8 {
        let (inc, dbl) = increment_and_double(x);
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(inc, dbl)
    }
}


//# run 0xCAFE::TestLambdaAndInline::add_u8_and_return_special --args 5u8 7u8


//# run 0xCAFE::TestLambdaAndInline::use_inline_and_lambda --args 3u8


//# publish
module 0xCAFE::SchemaAndTest {
    use std::signer;

    struct Inner has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        c: u8,
    }

    public fun create_schema_member(): Outer {
        // Construct schema member with nested structs and fields
        let inner = Inner { a: 1u8, b: 2u8 };
        let outer = Outer { inner, c: 3u8 };
        outer
    }

    public fun test(s: signer): u8 {
        let outer = create_schema_member();

        // Update inner values
        outer.inner.a = outer.inner.a + 5u8;
        outer.inner.b = outer.inner.b * 2u8;

        // Update outer c
        outer.c = outer.c - 1u8;

        // Compute sum for return: (a + b) + c
        let result = outer.inner.a + outer.inner.b + outer.c;

        // Use signer address in a dummy way
        let _addr = signer::address_of(&s);

        // Return the sum
        result
    }
}


//# run 0xCAFE::SchemaAndTest::create_schema_member


//# run 0xCAFE::SchemaAndTest::test --signers 0xBEEF


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6f730086fd9c9646b5f5fd957d8c3003: Create schema members within a module based on schema target specifications.
// 4d02191e76ff76955c80a9c3e7849b4f: Test that the `test` function correctly computes the sum of adjusted and manipulated values, including nested struct updates and arithmetic operations.
