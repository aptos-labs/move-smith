
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 200) {
            255u8
        } else {
            sum
        };
        // returning sum as the last expression
        sum
    }

    public fun run_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let res = a * b;
            res
        };
        lambda(x, y)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        0xCAFE::LambdaTest::add_two_u8(x, y)
    }
}


//# run 0xCAFE::LambdaTest::add_two_u8 --args 10u8 15u8


//# run 0xCAFE::LambdaTest::run_lambda --args 6u8 7u8


//# run 0xCAFE::LambdaTest::nested_call --args 20u8 22u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    public fun call_inline_function(x: u8, y: u8): u8 {
        LambdaTest::nested_call(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_inline_function --args 50u8 40u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
