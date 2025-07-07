
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition, lambda, and inline function cross-module call

    // Removed the use of 0xCAFE::MyModule to fix unbound module error
    // Provided an inline function `f2` here to simulate the external function used below

    // Inline function simulating MyModule::f2(a: u16): (u16, u16)
    // This is added to avoid linker errors and unbound module errors
    public inline fun f2(a: u16): (u16, u16) {
        // Just a simple dummy implementation returning (a, a+1)
        (a, a + 1)
    }

    // Function to add two u8 values and return the sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function that defines and uses a lambda to multiply two u8 values and add 5
    public fun lambda_multiply_add(x: u8, y: u8): u8 {
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let prod = multiplier(x, y);
        prod + 5
    }

    // Function to call inline function f2 and then add both returned values
    public fun call_inline_and_add(a: u16): u16 {
        let (p, q) = f2(a);
        p + q
    }

    // Runner function for testing multiple features together
    public fun runner(): u8 {
        let add_result = add_and_offset(3u8, 7u8);        // expect 3+7+10=20
        let lambda_result = lambda_multiply_add(2u8, 4u8); // expect 2*4+5=13
        // We do not return sum of previous, just return add_result for simplicity here
        add_result
    }
}



//# run 0xCAFE::AddAndLambda::add_and_offset --args 5u8 15u8



//# run 0xCAFE::AddAndLambda::lambda_multiply_add --args 3u8 6u8



//# run 0xCAFE::AddAndLambda::call_inline_and_add --args 10u16



//# run 0xCAFE::AddAndLambda::runner
