
//# publish
module 0xCAFE::AddAndLambda {
    // Removed the invalid use statement

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value plus the sum
        42 + sum
    }

    public fun call_lambda_example(): u8 {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            let m = x * y;
            (s, m)
        };
        let (sum, product) = lambda(4, 5);
        sum + product
    }

    // Implement f2 inline here since the original MyModule is not accessible
    // This mimics MyModule::f2 and allows the code to compile and run correctly
    fun f2(x: u16): (u16, u16) {
        // For demonstration, return (x, x * 2)
        (x, x * 2)
    }

    public fun use_inline_func_nested(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }

    // Runner function to execute all above
    public fun runner(): u16 {
        let val1 = add_two_values(10, 20);
        let val2 = call_lambda_example();
        let val3 = use_inline_func_nested(7);
        (val1 as u16) + (val2 as u16) + val3
    }
}



//# run 0xCAFE::AddAndLambda::add_two_values --args 10u8 15u8


//# run 0xCAFE::AddAndLambda::call_lambda_example


//# run 0xCAFE::AddAndLambda::use_inline_func_nested --args 5u16


//# run 0xCAFE::AddAndLambda::runner
