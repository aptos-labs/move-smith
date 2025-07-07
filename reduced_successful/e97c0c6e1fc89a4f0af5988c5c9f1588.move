
//# publish
module 0xCAFE::LambdaModule {
    // Removed `use 0xCAFE::MyModule` since it's not available, replace calls below with an inline function.

    /// Inline function to replace MyModule::f2(x: u16): (u16, u16)
    /// This function returns (x, x + 1) for testing nested calls.
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    public fun sum_two_u8(a: u8, b: u8): u8 {
        let res = a + b;
        // Return a specific constant after computing addition (e.g., res + 5)
        res + 5
    }

    public fun lambda_add_then_multiply(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            let add = a + b;
            let mul = a * b;
            (add, mul)
        };
        lambda(x, y)
    }

    public fun nested_inline_call(x: u16): (u16, u16) {
        // Use local inline function instead of MyModule::f2
        let (a, b) = f2(x);
        let (c, d) = f2(b);
        (a + c, b + d)
    }

    public fun curry_lambda_example(x: u8): (u8, u8) {
        // Lambda that captures x and returns a new lambda that adds y to captured x
        let captured = x;
        let curried: |u8| u8 has copy + drop = |y: u8| { captured + y };
        let add_result = curried(5u8);

        // Another lambda called immediately with add_result and x
        let lambda2: |u8, u8| u8 has copy + drop = |a: u8, b: u8| { a * b };
        let mul_result = lambda2(add_result, x);
        (add_result, mul_result)
    }

    public fun if_else_variable(): u8 {
        let x: u8;
        if (true) {
            let val = 10u8;
            x = val;
        } else {
            let val = 20u8;
            x = val;
        };
        // x should retain the value assigned in the if branch
        x
    }
}



//# run 0xCAFE::LambdaModule::sum_two_u8 --args 3u8 4u8



//# run 0xCAFE::LambdaModule::lambda_add_then_multiply --args 6u8 7u8



//# run 0xCAFE::LambdaModule::nested_inline_call --args 100u16



//# run 0xCAFE::LambdaModule::curry_lambda_example --args 10u8



//# run 0xCAFE::LambdaModule::if_else_variable
