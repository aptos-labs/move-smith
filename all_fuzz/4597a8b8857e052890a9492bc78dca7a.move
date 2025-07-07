
//# publish
module 0xCAFE::MathWithLambda {
    // A function to add two u8 values and return the sum plus a fixed offset 7
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 7u8
    }

    // Function containing a lambda that multiplies two values and adds a constant 3
    public fun lambda_mul_add(x: u8, y: u8): u8 {
        let mul_add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b + 3u8
        };
        mul_add_lambda(x, y)
    }

    // A runner function to test lambda_mul_add with fixed args
    public fun run_lambda_test(): u8 {
        lambda_mul_add(4u8, 5u8)
    }

    // Added function f2, as MyModule is not available
    // Returns (val, val * 2) as an example
    public fun f2(val: u16): (u16, u16) {
        (val, val * 2)
    }
}



//# run 0xCAFE::MathWithLambda::add_with_offset --args 10u8 20u8



//# run 0xCAFE::MathWithLambda::lambda_mul_add --args 3u8 7u8



//# run 0xCAFE::MathWithLambda::run_lambda_test




//# publish
module 0xCAFE::MathWithLambdaWrapper {
    use 0xCAFE::MathWithLambda;

    // Function that calls MathWithLambda::f2 (inline replacement for MyModule::f2)
    public fun call_my_module_f2(val: u16): (u16, u16) {
        MathWithLambda::f2(val)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathWithLambdaWrapper;

    // Calls function from MathWithLambdaWrapper that returns a tuple
    public fun call_inline_and_add(x: u16): u16 {
        let (a, b) = MathWithLambdaWrapper::call_my_module_f2(x);
        a + b
    }
}



//# run 0xCAFE::CallerModule::call_inline_and_add --args 5u16
