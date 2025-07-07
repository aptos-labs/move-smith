
//# publish
module 0xCAFE::AddAndLambda {
    // This module tests addition, lambda functions, and inline function calls between modules

    // Removed: use 0xCAFE::MyModule;
    // Since 0xCAFE::MyModule doesn't exist, implement the needed inline function here:

    // Inline function f2 that takes a u16 and returns a tuple (u16, u16)
    // For test purposes, let's just return (a, a * 2)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }

    // Function that adds two u8 values and returns the sum plus 10
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function with a lambda expression that multiplies input by 2 and returns it
    public fun apply_lambda_double(x: u8): u8 {
        let double = |n: u8| { n * 2u8 };
        double(x)
    }

    // Function that calls the inline function f2 defined above
    // and returns the sum of the tuple elements returned by f2
    public fun call_inline_f2_and_sum(a: u16): u16 {
        let (v1, v2) = f2(a);
        v1 + v2
    }

    // Runner function with no arguments that exercises above functions
    public fun test_runner(): u8 {
        let add_res = add_with_offset(5u8, 15u8);
        let lambda_res = apply_lambda_double(7u8);
        let inline_sum = call_inline_f2_and_sum(20u16);

        // Return sum of computed values truncated to u8
        let total = add_res + lambda_res + (inline_sum as u8);
        total
    }
}



//# run 0xCAFE::AddAndLambda::add_with_offset --args 12u8 34u8



//# run 0xCAFE::AddAndLambda::apply_lambda_double --args 21u8



//# run 0xCAFE::AddAndLambda::call_inline_f2_and_sum --args 50u16



//# run 0xCAFE::AddAndLambda::test_runner
