
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value 42 if sum equals 42, otherwise return sum
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b:u8| {
            a + b
        };
        adder(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_u8_values --args 20u8 22u8



//# run 0xCAFE::LambdaTest::lambda_example --args 10u8 15u8



//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        // Call the add_u8_values function from LambdaTest, which returns sum or 42
        let add_result = LambdaTest::add_u8_values(x, y);
        // Call lambda_example which sums x and y again
        let lambda_result = LambdaTest::lambda_example(x, y);

        // Return the sum of both results
        add_result + lambda_result
    }
}



//# run 0xCAFE::NestedCallTest::call_inline_and_lambda --args 5u8 6u8
