
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 to have a specific value return
        sum + 10
    }

    public fun lambda_example(): u8 {
        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x * 2
        };
        let res = lambda(5u8);
        res
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let incremented = inline_increment(x);
        incremented + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::ComputeAdd;

    public fun test_nested_calls(a: u8, b: u8): u8 {
        // call add_two_u8 from ComputeAdd module
        let sum_result = ComputeAdd::add_two_u8(a, b);

        // call call_inline_and_add from ComputeAdd module with sum_result and b
        let nested_result = ComputeAdd::call_inline_and_add(sum_result, b);

        nested_result
    }

    public fun test_lambda_and_add(a: u8, b: u8): u8 {
        let doubled = ComputeAdd::lambda_example();
        a + b + doubled
    }
}


//# run 0xCAFE::ComputeAdd::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::ComputeAdd::lambda_example


//# run 0xCAFE::ComputeAdd::call_inline_and_add --args 30u8 5u8


//# run 0xCAFE::CallerModule::test_nested_calls --args 2u8 3u8


//# run 0xCAFE::CallerModule::test_lambda_and_add --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
