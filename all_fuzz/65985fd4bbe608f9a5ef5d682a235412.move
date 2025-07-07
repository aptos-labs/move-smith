
//# publish
module 0xCAFE::MyModule {
    // define function f2 returning a tuple (u16, u16)
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::ComplexTest {
    use std::vector;

    // 1. Test addition of two u8 and return a fixed value after
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // sum is computed but we return a fixed number 42u8
        42u8
    }

    // 2. Lambda usage: a function that returns a lambda and calls it
    public fun lambda_expression_test(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    // 3. Call an inline function from another module (MyModule::f2) and add the tuple elements returned
    public fun call_inline_from_another_module(a: u16): u16 {
        let (v1, v2) = 0xCAFE::MyModule::f2(a);
        v1 + v2
    }

    // Nested inline functions
    public inline fun inner_inline(b: u16): (u16, u16) {
        (b, b + 1)
    }

    public inline fun outer_inline(c: u16): u16 {
        let (x, y) = inner_inline(c);
        x + y
    }

    // 6. Call nested inline from one function
    public fun call_nested_inlines(d: u16): u16 {
        outer_inline(d)
    }

    // 4. Nested loops with break, continue, and variable updates
    public fun complex_loop(): u8 {
        let x = 0u8;
        let i = 0u8;

        while (i < 10) {
            if (i == 5) {
                i = i + 1;
                continue;
            };
            if (i == 8) {
                break;
            };
            let j = 0u8;
            loop {
                if (j >= i) {
                    break;
                };
                if (j == 3) {
                    j = j + 1;
                    continue;
                };
                x = x + 1;
                j = j + 1;
            };
            i = i + 1;
        };
        // x accumulates count with skipping certain i and j values
        x
    }

    // 5. Literal values as standalone expressions
    public fun literals_standalone() {
        100u8;
        500u16;
        b"literal byte string";
        x"1234abcd";
        vector::empty<u8>();
    }
}



//# run 0xCAFE::ComplexTest::add_then_return_fixed --args 10u8 20u8



//# run 0xCAFE::ComplexTest::lambda_expression_test --args 15u8 25u8



//# run 0xCAFE::ComplexTest::call_inline_from_another_module --args 10u16



//# run 0xCAFE::ComplexTest::complex_loop



//# run 0xCAFE::ComplexTest::literals_standalone



//# run 0xCAFE::ComplexTest::call_nested_inlines --args 7u16
