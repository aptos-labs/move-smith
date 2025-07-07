
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let _sum = a + b; // mark sum as unused
        // Return a constant 42 when function ends
        42
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 11u8)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_specific_value --args 20u8 22u8



//# run 0xCAFE::LambdaTest::run_lambda_example




//# publish
module 0xCAFE::NestedInlineCall {
    // Removed unused import since inline_sum_and_increment is defined here
    // use 0xCAFE::LambdaTest; // Removed because it's unused

    // Inline function to return tuple of two u16 for test
    public inline fun inline_sum_and_increment(a: u16, b: u16): (u16, u16) {
        let sum = a + b;
        (sum, sum + 1)
    }

    public fun call_external_inline(a: u8, b: u8): u8 {
        let sum = a + b;
        let (x, y) = inline_sum_and_increment(sum as u16, 10u16);
        // Removed incorrect tuple unpack from run_lambda_example which returns u8:
        // let (r, _) = 0xCAFE::LambdaTest::run_lambda_example(); // wrong
        // Correct call:
        let ret = 0xCAFE::LambdaTest::run_lambda_example();
        (x as u8) + (y as u8) + ret
    }
}



//# run 0xCAFE::NestedInlineCall::call_external_inline --args 15u8 20u8
