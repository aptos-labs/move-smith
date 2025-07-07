
//# publish
module 0xCAFE::AdditionTest {
    // Test addition of two u8 values and return a specific u8 value

    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) { 42u8 } else { 24u8 };
        result
    }
}



//# run 0xCAFE::AdditionTest::add_then_return --args 5u8 6u8



//# publish
module 0xCAFE::LambdaTest {
    // Define and call functions containing lambda expressions

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun lambda_chain(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let add_result = add_lambda(a, b);
        let mul_result = mul_lambda(a, b);
        add_result + mul_result
    }
}



//# run 0xCAFE::LambdaTest::lambda_add --args 7u8 8u8



//# run 0xCAFE::LambdaTest::lambda_chain --args 3u8 4u8



//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AdditionTest;

    // The problem: call_addition_inline is declared inline, but AdditionTest::add_then_return is not inline.
    // This causes FUNCTION_RESOLUTION_FAILURE when trying to call a non-inline function from inline.

    // We fix it by removing inline from call_addition_inline, or by adding inline to add_then_return.
    // The better fix: remove inline from call_addition_inline since AdditionTest::add_then_return is not inline.

    public fun call_addition_inline(a: u8, b: u8): u8 {
        AdditionTest::add_then_return(a, b)
    }

    public fun call_addition_plus_extra(a: u8, b: u8): u8 {
        let base = call_addition_inline(a, b);
        base + 1u8
    }
}



//# run 0xCAFE::NestedInlineCaller::call_addition_inline --args 2u8 3u8



//# run 0xCAFE::NestedInlineCaller::call_addition_plus_extra --args 6u8 7u8
