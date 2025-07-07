
//# publish
module 0xCAFE::AddAndReturn {
    // Test that the Move function correctly computes addition of two u8 values before returning a specific value

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // return sum + 1u8 to have a predictable output
        sum + 1u8
    }

    public fun test_lambda_expression(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b + 1u8
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 20u8


//# run 0xCAFE::AddAndReturn::test_lambda_expression --args 5u8 7u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndReturn;

    // Test calling inline function from another module and nested function calls returning expected result

    public inline fun twice_add(a: u8, b: u8): u8 {
        let result = AddAndReturn::add_and_return(a, b);
        AddAndReturn::add_and_return(result, b)
    }

    public fun call_twice_add(a: u8, b: u8): u8 {
        twice_add(a, b)
    }
}


//# run 0xCAFE::InlineCaller::call_twice_add --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
