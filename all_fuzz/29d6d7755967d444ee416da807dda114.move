
//# publish
module 0xCAFE::MathAndLambda {

    // Function to add two u8 values and then add specific offset 10u8 before returning
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    // Function demonstrating lambda expressions: takes two u8 and computes sum and product
    public fun lambda_operations(x: u8, y: u8): (u8, u8) {
        let sum_lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        sum_lambda(x, y)
    }

    // Instead of calling MyModule::f2(), write a local inline function f2
    // matching the expected signature: f2(u16): (u16, u16)
    // Then call it and sum the parts as u32.

    fun f2(a: u16): (u16, u16) {
        // example implementation: return (a, a * 2)
        (a, a * 2)
    }

    // Function to call inline function f2 with given argument and then sum parts
    public fun call_inline_and_sum(a: u16): u32 {
        let (v1, v2) = f2(a);
        (v1 + v2) as u32
    }
}



//# run 0xCAFE::MathAndLambda::add_and_offset --args 7u8 8u8



//# run 0xCAFE::MathAndLambda::lambda_operations --args 5u8 6u8



//# run 0xCAFE::MathAndLambda::call_inline_and_sum --args 20u16
