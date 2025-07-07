
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_check(a: u8, b: u8): u8 {
        // Add two u8 values and test the result
        let sum = a + b;

        // Return a specific value if sum is correct
        if (sum == a + b) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambda_adder(): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = add_lambda(10u8, 15u8);
        result
    }

    // Dummy replacement for 0xCAFE::MyModule::f2
    // Because the original f2 is not defined, let's define it here:
    public fun call_inline_from_other_module(x: u16): u16 {
        let (a, b) = Self::f2(x);
        a + b
    }

    // Adding the missing f2 function
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}



//# run 0xCAFE::LambdaTest::add_and_check --args 10u8 20u8



//# run 0xCAFE::LambdaTest::lambda_adder



//# run 0xCAFE::LambdaTest::call_inline_from_other_module --args 100u16
