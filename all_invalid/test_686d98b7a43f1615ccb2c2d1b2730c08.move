//# publish
module 0xA11C::TestInlineFunction {
    // Inline function 'foo' that calls two function parameters with provided arguments and returns their combined sum
    inline fun foo(f: |u64, u64| u64, g: |u64, u64| u64, x: u64, y: u64): u64 {
        f(x, y) + g(x, y)
    }

    // Function to test the inline behavior by passing in functions that perform specific computations
    public fun test(): bool {
        // Define a function that adds its arguments
        let add_fn = |a: u64, b: u64| { a + b };
        // Define a function that multiplies its arguments
        let mul_fn = |a: u64, b: u64| { a * b };

        // Call inline function 'foo' with add and mul functions
        let result_add_mul = foo(add_fn, mul_fn, 5, 10); // (5+10) + (5*10) = 15 + 50 = 65
        // Call inline function 'foo' with mul and add functions
        let result_mul_add = foo(mul_fn, add_fn, 4, 2); // (4*2) + (4+2) = 8 + 6 = 14

        // Verify the results
        result_add_mul == 65 && result_mul_add == 14
    }
}

//# run 0xA11C::TestInlineFunction::test