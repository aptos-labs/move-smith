
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 10) {
            5u8
        } else {
            10u8
        }
    }

    public fun lambda_test(): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        // Call the lambda with 3 and 4, expect 7
        let result = f(3u8, 4u8);
        result
    }
}


//# run 0xCAFE::AddAndReturn::add_and_check --args 3u8 4u8


//# run 0xCAFE::AddAndReturn::add_and_check --args 7u8 5u8


//# run 0xCAFE::AddAndReturn::lambda_test


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndReturn;

    public inline fun identity(x: u8): u8 {
        x
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let sum = AddAndReturn::add_and_check(a, b);
        let id = identity(sum);
        id
    }
}


//# run 0xCAFE::InlineCaller::nested_calls --args 2u8 6u8


//# run 0xCAFE::InlineCaller::nested_calls --args 9u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
