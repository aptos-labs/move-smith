
//# publish
module 0xCAFE::MathAndLambda {

    // Simple add function that adds two u8 numbers and returns sum + 1
    public fun add_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function that uses a lambda to multiply two u8 and add a constant 5 to it
    public fun lambda_multiply_add(a: u8, b: u8): u8 {
        let mul_add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let product = x * y;
            product + 5u8
        };
        mul_add(a, b)
    }

    // Inline helper function within this module to replace MyModule::f2
    public inline fun f2(a: u16): (u16, u16) {
        // Example implementation to allow compilation and meaningful test
        // Split 'a' in half and return as tuple values
        let v1 = a / 2;
        let v2 = a - v1;
        (v1, v2)
    }

    // Function testing inline function f2 from this module by calling it
    // and returning the sum of its returned tuple values
    public fun test_inline_function(a: u16): u16 {
        let (v1, v2) = f2(a);
        v1 + v2
    }
}



//# run 0xCAFE::MathAndLambda::add_plus_one --args 7u8 8u8



//# run 0xCAFE::MathAndLambda::lambda_multiply_add --args 3u8 4u8



//# run 0xCAFE::MathAndLambda::test_inline_function --args 10u16
