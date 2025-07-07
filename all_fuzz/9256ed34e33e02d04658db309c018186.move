
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let result = adder(x, y);
        // Return result multiplied by 2
        result * 2u8
    }

    public fun nested_lambda(): u8 {
        let multiply_by_two: |u8| u8 has copy+drop = |n: u8| { n * 2u8 };
        let add_and_double = |a: u8, b: u8| {
            let sum = a + b;
            multiply_by_two(sum)
        };
        add_and_double(3u8, 4u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_u8 --args 5u8 6u8


//# run 0xCAFE::AddAndLambda::add_u8 --args 2u8 3u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::nested_lambda


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndLambda;

    public fun call_add_and_lambda(a: u8, b: u8): (u8, u8, u8) {
        let added = AddAndLambda::add_u8(a, b);
        let lambda_result = AddAndLambda::use_lambda(a, b);
        let nested_result = AddAndLambda::nested_lambda();
        (added, lambda_result, nested_result)
    }
}


//# run 0xCAFE::CallerModule::call_add_and_lambda --args 4u8 9u8


//# run 0xCAFE::CallerModule::call_add_and_lambda --args 1u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
