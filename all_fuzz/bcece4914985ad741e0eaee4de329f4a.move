
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Example implementation 
        // to return (x, x * 2) - adjust as needed for your test
        (x, x * 2)
    }
}

//# publish
module 0xCAFE::LambdaTests {
    const CONST_ADD_RESULT: u8 = 42;

    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;

        // Use loop to reduce sum by 1 until less than or equal to 50
        let current = sum;
        while (current > 50) {
            current = current - 1;
        };

        // Loop to subtract 1 until exactly 42
        loop {
            if (current == CONST_ADD_RESULT) {
                break;
            };
            current = current - 1;
        };

        current
    }

    public fun run_lambda_example(x: u8): u8 {
        let lambda: |u8|u8 has copy + drop = |a: u8| {
            if (a > 10) {
                a - 10
            } else {
                a + 10
            }
        };
        lambda(x)
    }

    public fun call_nested_inline_function(x: u16): u32 {
        // Call function in another module that returns (u16, u16) tuple
        let (a, b) = 0xCAFE::MyModule::f2(x);
        // Return sum as u32
        (a as u32) + (b as u32)
    }
}



//# run 0xCAFE::LambdaTests::add_two_u8_values --args 25u8 30u8



//# run 0xCAFE::LambdaTests::run_lambda_example --args 15u8



//# run 0xCAFE::LambdaTests::run_lambda_example --args 5u8



//# run 0xCAFE::LambdaTests::call_nested_inline_function --args 20u16
