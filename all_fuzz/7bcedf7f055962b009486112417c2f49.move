
//# publish
module 0xCAFE::MathWithLambda {

    // Define f2 here to replace MyModule::f2(a)
    public fun f2(a: u16): (u16, u16) {
        // Example logic: return (a + 1, a + 2)
        (a + 1, a + 2)
    }

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 5 to test addition logic
        sum + 5
    }

    public fun lambda_operations(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let multiply_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let add_result = add_lambda(x, y);
        let mul_result = multiply_lambda(x, y);
        // Return sum of both lambda results
        add_result + mul_result
    }

    public fun call_inline_and_return(a: u16): u16 {
        let (res1, res2) = f2(a);
        res1 + res2
    }

    public fun runner() {
        let _ = add_and_return_sum(10u8, 20u8);
        let _ = lambda_operations(4u8, 5u8);
        let _ = call_inline_and_return(100u16);
    }
}



//# run 0xCAFE::MathWithLambda::add_and_return_sum --args 10u8 15u8



//# run 0xCAFE::MathWithLambda::lambda_operations --args 3u8 7u8



//# run 0xCAFE::MathWithLambda::call_inline_and_return --args 15u16



//# run 0xCAFE::MathWithLambda::runner
