
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to check correctness of addition and return
        sum + 1
    }

    public fun lambda_addition(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(10u8, 20u8)
    }

    public inline fun inline_identity(x: u8): u8 {
        x
    }
}


//# run 0xCAFE::LambdaTest::add_two_numbers --args 5u8 7u8


//# run 0xCAFE::LambdaTest::lambda_addition


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_inline_identity(x: u8): u8 {
        LambdaTest::inline_identity(x)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let first = LambdaTest::add_two_numbers(x, y);
        let second = call_inline_identity(first);
        second
    }
}


//# run 0xCAFE::InlineCaller::call_inline_identity --args 42u8


//# run 0xCAFE::InlineCaller::nested_call --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
