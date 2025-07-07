
//# publish
module 0xCAFE::MyModule {
    // Provide the missing function f2 so LambdaTest can compile and run correctly
    public fun f2(x: u16): (u16, u16) {
        // Simple example: return x and x * 2
        (x, x * 2)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    // Remove unused import
    // use std::vector;

    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10u8 as a specific value to test with
        sum + 10u8
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        // Define a lambda with copy+drop ability explicitly
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let result = adder(x, y);
        result
    }

    public fun nested_inline_call(x: u16): u16 {
        // Calls inline function from MyModule for nested calls test
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }

    // Function to test usage of numeric tokens as field names (simulate)
    // Ideally fields cannot start with numbers but here we use local vars named with digits pattern to simulate
    public fun numeric_tokens_simulation(): u8 {
        let _1 = 1u8;
        let _2 = 2u8;
        let _3 = _1 + _2;
        _3
    }

    // Lint check example function
    public fun lint_check_example(x: u8, y: bool): u8 {
        if (y) {
            let result = x + 5u8;
            result
        } else {
            let result = x + 10u8;
            result
        };
        // We want final value returned no semicolon at the end
        if (y) { 100u8 } else { 200u8 }
    }
}



//# run 0xCAFE::LambdaTest::add_and_check --args 10u8 15u8



//# run 0xCAFE::LambdaTest::lambda_example --args 5u8 7u8



//# run 0xCAFE::LambdaTest::nested_inline_call --args 20u16



//# run 0xCAFE::LambdaTest::numeric_tokens_simulation



//# run 0xCAFE::LambdaTest::lint_check_example --args 42u8 true
