
//# publish
module 0xCAFE::MyModule {
    // Define the missing inline function f2 that returns two u16 values
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            100u8
        } else {
            sum
        }
    }

    public fun use_lambda_expression(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(5u8, 10u8);
        result
    }

    public fun call_inline_nested(): u32 {
        // Calls 0xCAFE::MyModule::f2 inline function and uses the return values
        let (v1, v2) = 0xCAFE::MyModule::f2(20u16);
        let total = v1 + v2;
        total as u32
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_specific_value --args 40u8 2u8



//# run 0xCAFE::LambdaTest::add_and_return_specific_value --args 10u8 5u8



//# run 0xCAFE::LambdaTest::use_lambda_expression



//# run 0xCAFE::LambdaTest::call_inline_nested
