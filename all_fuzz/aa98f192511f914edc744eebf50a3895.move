
//# publish
module 0xCAFE::AddTest {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }
}


//# run 0xCAFE::AddTest::add_then_return --args 40u8 50u8


//# publish
module 0xCAFE::LambdaTest {
    public fun call_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| {
            n + 5
        };
        lambda(x)
    }

    public fun call_multiple_lambdas(x: u8, y: u8): u8 {
        let add_five: |u8|u8 has copy+drop = |n: u8| { n + 5 };
        let times_two: |u8|u8 has copy+drop = |n: u8| { n * 2 };
        let result = add_five(x);
        times_two(y) + result
    }
}


//# run 0xCAFE::LambdaTest::call_lambda --args 10u8


//# run 0xCAFE::LambdaTest::call_multiple_lambdas --args 3u8 7u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddTest;

    public inline fun call_add_then_return_inline(x: u8, y: u8): u8 {
        AddTest::add_then_return(x, y)
    }

    public fun call_inline_function(x: u8, y: u8): u8 {
        call_add_then_return_inline(x, y)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_function --args 20u8 30u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
