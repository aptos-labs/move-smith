
//# publish
module 0xCAFE::LambdaTest {
    public fun test_lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun test_lambda_capture(z: u8): u8 {
        let lambda_with_capture: |u8|u8 has copy+drop = |a: u8| {
            a + z
        };
        lambda_with_capture(5u8)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_lambda_add(a: u8, b: u8): u8 {
        LambdaTest::test_lambda_add(a, b)
    }

    public fun caller_function(): u8 {
        let res = call_lambda_add(10u8, 20u8);
        res
    }
}


//# run 0xCAFE::LambdaTest::test_lambda_add --args 4u8 5u8


//# run 0xCAFE::LambdaTest::test_lambda_capture --args 3u8


//# run 0xCAFE::InlineCaller::caller_function


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0d204db543be922c4a3dbcbe1eb0916e: Prevent duplicate attributes from being attached to the same item.
