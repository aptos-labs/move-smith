
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return a fixed value ignoring sum to test return behavior
        42u8
    }

    public fun with_lambda_expr(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // Provide a local stub for MyModule::f2 returning a tuple (u16, u16)
    // so that the call compiles and runs successfully.
    fun f2(x: u16): (u16, u16) {
        // For example, return (x, x + 1)
        (x, x + 1)
    }

    public fun use_inline_f2(x: u16): u32 {
        // Call the local stub f2 rather than an undefined external
        let (a, b) = f2(x);
        (a as u32) + (b as u32)
    }
}



//# run 0xCAFE::LambdaTest::add_then_return --args 10u8 20u8



//# run 0xCAFE::LambdaTest::with_lambda_expr --args 15u8 25u8



//# run 0xCAFE::LambdaTest::use_inline_f2 --args 100u16
