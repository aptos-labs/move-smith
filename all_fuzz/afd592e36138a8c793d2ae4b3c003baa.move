
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_sum_and_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let constant = 42u8;
        sum + constant
    }

    public fun call_with_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| { v + 1 };
        lambda(x)
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_sum_and_constant --args 10u8 20u8


//# run 0xCAFE::LambdaTest::call_with_lambda --args 5u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let sum = inline_add(x, y);
        let res = LambdaTest::add_then_return_sum_and_constant(sum, 1u8);
        res
    }

    public fun test_string_literals(): vector<u8> {
        let byte_str = b"test_byte_string\n";
        let hex_str = x"deadbeef";
        byte_str
    }
}


//# run 0xCAFE::NestedInlineCall::nested_calls --args 3u8 4u8


//# run 0xCAFE::NestedInlineCall::test_string_literals


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// cb19d976d9a2ac70303450da8ed87c20: Use string literals only with b" and x" prefixes; plain string literals are disallowed.
