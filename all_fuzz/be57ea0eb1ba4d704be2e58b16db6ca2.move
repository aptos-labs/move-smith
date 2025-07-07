
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_two_u8_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_double_twice(x: u8): u8 {
        let double: |u8| u8 has copy+drop = |a: u8| a * 2;
        // Apply the lambda twice
        double(double(x))
    }

    public fun lambda_add_then_multiply(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let multiply: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;

        let sum = add(x, y);
        multiply(sum, 2)
    }
}


//# run 0xCAFE::AddAndReturn::add_two_u8_and_return_sum --args 10u8 15u8


//# run 0xCAFE::AddAndReturn::lambda_double_twice --args 3u8


//# run 0xCAFE::AddAndReturn::lambda_add_then_multiply --args 2u8 4u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturn;

    public fun call_add_twice(x: u8, y: u8): u8 {
        let first_sum = AddAndReturn::add_two_u8_and_return_sum(x, y);
        let second_sum = AddAndReturn::add_two_u8_and_return_sum(first_sum, y);
        second_sum
    }

    public fun runner(): u8 {
        call_add_twice(5u8, 10u8)
    }
}


//# run 0xCAFE::NestedCalls::call_add_twice --args 7u8 8u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
