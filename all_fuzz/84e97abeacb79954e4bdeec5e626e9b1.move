
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused 'use std::signer;' as it's not used in the module

    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _lambda: |u8| u8 has drop = |x: u8| { x + sum };
        // The function returns 42 regardless of sum
        42
    }

    public fun lambda_expression_example(x: u8): u8 {
        let add_two: |u8| u8 has copy+drop = |n: u8| { n + 2 };
        let mul_two: |u8| u8 = |n: u8| { n * 2 };
        let result = add_two(x);
        mul_two(result)
    }

    public fun runner() {
        let _ = add_then_return_fixed(5u8, 10u8);
        let _ = lambda_expression_example(3u8);
    }
}



//# run 0xCAFE::LambdaTest::runner



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun inline_increment(x: u8): u8 {
        // Inline function that returns x+1
        x + 1
    }

    public fun nested_inline_call(x: u8): u8 {
        // Call an inline function from within this module
        let y = inline_increment(x);
        // Call a lambda from another module that adds then returns fixed value
        let fixed = LambdaTest::add_then_return_fixed(y, 2u8);
        fixed
    }

    public fun runner() {
        let _ = nested_inline_call(10u8);
    }
}



//# run 0xCAFE::InlineCallTest::runner
