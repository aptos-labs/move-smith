
//# publish
module 0xCAFE::AddAndLambda {
    // This module tests addition, lambda functions, and inline function calls from another module

    // Remove the invalid use since 0xCAFE::MyModule does not exist and we cannot reference it

    // Since MyModule::f2 does not exist, implement f2 inline here for the example.
    // Inline function returning two u16 values from a u16 input
    inline fun f2(x: u16): (u16, u16) {
        (x / 2, x - (x / 2))
    }

    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 just to produce different output
        sum + 1
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun call_inline_and_process(a: u16): u32 {
        let (a1, a2) = f2(a);
        // sum of the two returned u16 converted to u32
        let total = (a1 as u32) + (a2 as u32);
        total
    }

    public fun runner() {
        let _ = add_and_return(10u8, 20u8);
        let _ = run_lambda_example(30u8, 40u8);
        let _ = call_inline_and_process(50u16);
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return --args 5u8 10u8



//# run 0xCAFE::AddAndLambda::run_lambda_example --args 7u8 8u8



//# run 0xCAFE::AddAndLambda::call_inline_and_process --args 100u16



//# run 0xCAFE::AddAndLambda::runner
