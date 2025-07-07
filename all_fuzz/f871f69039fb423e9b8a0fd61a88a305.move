
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return_value(x: u8, y: u8): u8 {
        let sum = x + y;
        let ret = if (sum > 10) {
            42u8
        } else {
            24u8
        };
        ret
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return_value --args 3u8 4u8


//# publish
module 0xCAFE::LambdaExamples {
    public fun call_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = add(x, y);
        let product = mul(x, y);
        sum + product
    }

    public fun nested_lambda(x: u8): u8 {
        let inc: |u8| u8 has copy+drop = |a: u8| { a + 1 };
        let double: |u8| u8 has copy+drop = |a: u8| { a * 2 };
        let result = double(inc(x));
        result
    }
}


//# run 0xCAFE::LambdaExamples::call_lambda --args 3u8 5u8


//# run 0xCAFE::LambdaExamples::nested_lambda --args 7u8


//# publish
module 0xCAFE::NestedInlineCalls {
    use 0xCAFE::AddAndReturn;

    public inline fun f_add(a: u8, b: u8): u8 {
        AddAndReturn::add_and_return_value(a, b)
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let first_call = f_add(x, y);
        // Call add_and_return_value directly and f_add inline function to test nested call
        let second_call = AddAndReturn::add_and_return_value(first_call, 1);
        let third_call = f_add(second_call, 2);
        third_call
    }
}


//# run 0xCAFE::NestedInlineCalls::nested_calls --args 4u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
