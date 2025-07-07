
//# publish
module 0xCAFE::NestedInline {
    // An inline function adding two u8 and then multiplying by 3
    public inline fun inline_add_and_multiply(a: u8, b: u8): u8 {
        let sum = a + b;
        sum * 3
    }
}



//# publish
module 0xCAFE::AddAndLambda {
    // removed unused 'use std::signer;'

    // This function adds two u8 values and returns the sum plus a constant offset (10)
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Normal function to double a u8 value
    fun double(x: u8): u8 {
        x * 2
    }

    // This function takes two u8 parameters and applies a "lambda" that multiplies by two
    public fun lambda_double_and_add(a: u8, b: u8): u8 {
        let doubled_a = double(a);
        let sum = doubled_a + b;
        sum
    }

    // A function calling a nested inline function from another module 0xCAFE::NestedInline
    public fun call_nested_inline(a: u8, b: u8): u8 {
        0xCAFE::NestedInline::inline_add_and_multiply(a, b)
    }

    public fun runner() {
        let _ = add_and_offset(3u8, 4u8);
        let _ = lambda_double_and_add(2u8, 5u8);
        let _ = call_nested_inline(3u8, 4u8);
    }
}



//# run 0xCAFE::AddAndLambda::add_and_offset --args 12u8 8u8



//# run 0xCAFE::AddAndLambda::lambda_double_and_add --args 5u8 10u8



//# run 0xCAFE::AddAndLambda::call_nested_inline --args 1u8 2u8



//# run 0xCAFE::AddAndLambda::runner
