
//# publish
module 0xCAFE::LambdaTest {
    // Test module for lambdas and inline function calls

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_and_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            add_u8(x, y)
        };
        lambda(a, b)
    }

    public fun embedded_lambda(): u8 {
        let f: |u8| |u8|u8 has copy+drop = |x: u8| {
            let g: |u8|u8 has copy+drop = |y: u8| {
                add_u8(x, y)
            };
            g
        };
        let h = f(3u8);
        h(4u8)
    }
}


//# run 0xCAFE::LambdaTest::call_lambda_and_add --args 7u8 8u8


//# run 0xCAFE::LambdaTest::embedded_lambda



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    // Calls the inline function add_u8 from LambdaTest
    public fun call_inline_add(a: u8, b: u8): u8 {
        LambdaTest::add_u8(a, b)
    }

    // Calls call_lambda_and_add in LambdaTest
    public fun call_lambda_through_module(a: u8, b: u8): u8 {
        LambdaTest::call_lambda_and_add(a, b)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_add --args 10u8 15u8


//# run 0xCAFE::InlineCaller::call_lambda_through_module --args 20u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
