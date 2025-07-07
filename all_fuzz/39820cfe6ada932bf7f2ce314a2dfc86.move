
//# publish
module 0xCAFE::LambdaTest {
    // LambdaTest module tests lambda expressions and addition of two u8 values.

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // return fixed u8 value 42 if sum equals 42, else return sum directly
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun lambda_usage(a: u8, b: u8): (u8, u8) {
        // A lambda that adds and multiplies two u8 numbers, returns tuple
        let lambda: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        let (add_result, mul_result) = lambda(a, b);
        (add_result, mul_result)
    }
}




//# run 0xCAFE::LambdaTest::add_two_values --args 21u8 21u8




//# run 0xCAFE::LambdaTest::add_two_values --args 10u8 5u8




//# run 0xCAFE::LambdaTest::lambda_usage --args 3u8 4u8





//# publish
module 0xCAFE::InlineCaller {
    // Import statements are not valid inside modules in Move.
    // So instead, we will qualify function calls fully by module address and name.

    // Calls a LambdaTest function from another module and returns result doubled
    public fun call_inline_from_other_module(x: u8, y: u8): u8 {
        let sum = 0xCAFE::LambdaTest::add_two_values(x, y);
        sum * 2
    }
}




//# run 0xCAFE::InlineCaller::call_inline_from_other_module --args 10u8 11u8



//# run 0xCAFE::InlineCaller::call_inline_from_other_module --args 21u8 21u8
