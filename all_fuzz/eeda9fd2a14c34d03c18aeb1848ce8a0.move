
//# publish
module 0xCAFE::FunctionTests {
    // Removed `use std::signer;` since it's unused and caused a warning.
    // Removed reference to non-existent module 0xCAFE::MyModule as per guidelines.

    // 1. Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus a constant offset 10
        sum + 10
    }

    // 2. Write functions containing lambda (anonymous function) expressions.
    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };

        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };

        let sum = add_lambda(x, y);
        let product = mul_lambda(x, y);
        sum + product
    }

    // 3. Provide an equivalent function inline instead of calling an external (unavailable) module.
    public fun call_inline_and_process(x: u16): u32 {
        // Since 0xCAFE::MyModule does not exist, we simulate the f2 function here.
        // Assume f2 returns a tuple (u16, u16), for example: (x, x*2).
        let a: u16 = x;
        let b: u16 = x * 2;

        // Return a + b plus a constant 100
        (((a as u32) + (b as u32)) + 100)
    }

    // A wrapper function to run all tests inside this module
    public fun run_all() {
        let _ = add_and_return(3u8, 7u8);
        let _ = lambda_example(4u8, 5u8);
        let _ = call_inline_and_process(20u16);
    }
}
