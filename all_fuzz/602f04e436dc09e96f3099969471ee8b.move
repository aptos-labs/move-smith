
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8 // return a specific value, unrelated to sum to test the function returns as expected
    }

    public fun lambda_example(): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        let result = add(5u8, 7u8);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add(): u8 {
        let res = inline_add(3u8, 4u8);
        res
    }

    public fun return_ten(): u8 {
        let val = 10u8;
        val
    }
}


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_nested_inline(x: u8, y: u8): u8 {
        // Calls the inline function inline_add defined in LambdaTest from here
        LambdaTest::inline_add(x, y)
    }
}


//# run 0xCAFE::LambdaTest::add_then_return --args 2u8 3u8


//# run 0xCAFE::LambdaTest::lambda_example


//# run 0xCAFE::NestedInlineCaller::call_nested_inline --args 6u8 4u8


//# run 0xCAFE::LambdaTest::return_ten


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9b3b414c1289e41cdd9f366bec5543a8: Test that the module's public function returns the value 10 after assigning it to a local variable.
