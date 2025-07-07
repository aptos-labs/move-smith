
//# publish
module 0xCAFE::LambdaAndInline {

    // Simple function that adds two u8 and returns 42u8
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // just to demonstrate sum usage
        42u8
    }

    // Function containing a lambda that multiplies two u8 values and returns the result
    public fun apply_lambda_mult(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    // Inline function that takes a u16 and returns a tuple of two u16 values
    public inline fun f2(val: u16): (u16, u16) {
        // For example, return (val, val * 2)
        (val, val * 2)
    }

    // Call the inline function f2 defined above and sum its returned tuple elements
    public fun call_inline_and_sum(val: u16): u16 {
        let (a, b) = f2(val);
        a + b
    }

    // Runner function with no arguments just calls the above functions to ensure coverage
    public fun runner() {
        let _res1 = add_and_return_42(5u8, 10u8);
        let _res2 = apply_lambda_mult(3u8, 7u8);
        let _res3 = call_inline_and_sum(20u16);
    }
}



//# run 0xCAFE::LambdaAndInline::add_and_return_42 --args 7u8 8u8



//# run 0xCAFE::LambdaAndInline::apply_lambda_mult --args 4u8 5u8



//# run 0xCAFE::LambdaAndInline::call_inline_and_sum --args 15u16



//# run 0xCAFE::LambdaAndInline::runner
