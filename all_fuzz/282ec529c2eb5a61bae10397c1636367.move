
//# publish
module 0xCAFE::LambdaTest {
    // Test Move function computing addition of two u8 values and returning a specific value

    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function with lambda expressions
    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };

        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };

        let addition_result = add_lambda(x, y);
        let multiplication_result = mul_lambda(x, y);
        (addition_result, multiplication_result)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    // Call the function from LambdaTest directly; do not inline across modules
    // The 'inline' modifier is not supported for cross-module function calls
    public fun call_add_and_increment(input1: u8, input2: u8): u8 {
        LambdaTest::add_and_increment(input1, input2)
    }

    public fun runner(): u8 {
        let x = 10u8;
        let y = 20u8;
        call_add_and_increment(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_and_increment --args 5u8 6u8



//# run 0xCAFE::LambdaTest::use_lambda --args 7u8 8u8



//# run 0xCAFE::InlineCaller::call_add_and_increment --args 100u8 27u8



//# run 0xCAFE::InlineCaller::runner
