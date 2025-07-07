
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        LambdaTest::inline_add(a, b)
    }

    public fun call_add_two_values_and_inline(x: u8, y: u8): u8 {
        let sum = LambdaTest::add_two_values(x, y); // sum = x+y + 10
        call_inline_add(sum, 5u8) // sum + 5
    }

    public fun runner(): u8 {
        call_add_two_values_and_inline(3u8, 4u8) // (3+4)+10 =17 +5 =22
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 5u8 6u8


//# run 0xCAFE::LambdaTest::apply_lambda --args 4u8 7u8


//# run 0xCAFE::NestedCall::call_inline_add --args 8u8 9u8


//# run 0xCAFE::NestedCall::call_add_two_values_and_inline --args 2u8 3u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
