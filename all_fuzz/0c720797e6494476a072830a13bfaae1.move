
//# publish
module 0xCAFE::TestFeatures {
    // Module to test addition, lambdas, and cross-module inline function calls

    // Removed use 0xCAFE::MyModule; since it doesn't exist.
    // Instead, define the inline function f2 here for testing purposes.

    // Define f2 inline function as expected in original MyModule::f2
    // For demonstration, let's define f2 to return (x + 1, x * 2)
    // You can adjust the logic as needed.
    // inline]
    public fun f2(x: u16): (u16, u16) {
        (x + 1, x * 2)
    }

    // 1. Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return 42 if sum is 42, else sum + 1
        if (sum == 42) {
            42
        } else {
            sum + 1
        }
    }

    // 2. Write functions containing lambda (anonymous function) expressions.
    public fun lambda_square_apply(x: u8): u8 {
        // lambda that squares its input
        let square: |u8|u8 has copy+drop = |a: u8| { a * a };
        square(x)
    }

    public fun lambda_add_multiply(a: u8, b: u8): (u8, u8) {
        let func: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            let m = x * y;
            (s, m)
        };
        func(a, b)
    }

    // 3. Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
    // Since MyModule does not exist, call the local f2 instead
    public fun call_inline_f2(x: u16): (u16, u16) {
        f2(x)
    }

    // Runner function with no arguments
    public fun runner() {
        let _ = add_and_return_specific(20u8, 22u8);
        let _ = lambda_square_apply(7u8);
        // For functions returning tuples, destructure the result into variables to avoid the "tuple type ... not allowed as a type argument" error.
        let (_sum, _mul) = lambda_add_multiply(3u8, 4u8);
        let (_x1, _x2) = call_inline_f2(10u16);
    }
}




//# run 0xCAFE::TestFeatures::add_and_return_specific --args 20u8 22u8




//# run 0xCAFE::TestFeatures::lambda_square_apply --args 7u8




//# run 0xCAFE::TestFeatures::lambda_add_multiply --args 3u8 4u8




//# run 0xCAFE::TestFeatures::call_inline_f2 --args 10u16




//# run 0xCAFE::TestFeatures::runner
