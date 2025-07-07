
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun call_lambda_with_value(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun assign_locals(a: u8, b: u8): (u8, u8) {
        let x = a;
        let y = b;
        (x, y)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_specific --args 7u8 8u8


//# run 0xCAFE::LambdaTest::call_lambda_with_value --args 13u8


//# run 0xCAFE::LambdaTest::assign_locals --args 5u8 6u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let sum = LambdaTest::inline_add(a, b);
        LambdaTest::add_and_return_specific(sum, 5u8)
    }
}


//# run 0xCAFE::NestedCalls::nested_inline_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a4fe7db2390dba35925d2efeae1a9883: Assign to local variables directly.
