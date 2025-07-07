
//# publish
module 0xCAFE::MyModule {
    // We add this module because LambdaTest calls MyModule::f2 in call_inline_function.

    public fun f2(x: u16): (u16, u16) {
        // For example, returns (x + 1, x + 2)
        (x + 1, x + 2)
    }
}



//# publish
module 0xCAFE::LambdaTest {
    // Module to test anonymous function expressions and addition

    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Ignores sum and returns a fixed value 42
        42
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(2u8, 3u8)
    }

    public fun call_inline_function(a: u16): u16 {
        // Calls inline function from MyModule::f2 and then returns first element
        let (val1, _val2) = 0xCAFE::MyModule::f2(a);
        val1
    }
}




//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 10u8 15u8



//# run 0xCAFE::LambdaTest::run_lambda_example



//# run 0xCAFE::LambdaTest::call_inline_function --args 100u16
