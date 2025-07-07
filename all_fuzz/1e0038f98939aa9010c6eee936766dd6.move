
//# publish
module 0xCAFE::AddLambda {
    use std::vector;

    // Function that adds two u8 values and returns the sum + 10
    public fun add_and_adjust(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function containing a lambda that multiplies a u8 by 2 and adds 3
    public fun lambda_example(x: u8): u8 {
        let double_plus_three: |u8|u8 has copy+drop = |n: u8| {
            n * 2 + 3
        };
        double_plus_three(x)
    }
}


//# run 0xCAFE::AddLambda::add_and_adjust --args 5u8 6u8


//# run 0xCAFE::AddLambda::lambda_example --args 7u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddLambda;

    // Inline function to multiply by 3 and add 1
    public inline fun multiply_add(x: u8): u8 {
        x * 3 + 1
    }

    // Calls AddLambda::add_and_adjust and NestedCalls::multiply_add and returns their sum
    public fun nested_call_adds(a: u8, b: u8): u8 {
        let add_result = AddLambda::add_and_adjust(a, b);
        let mult_result = multiply_add(a + b);
        add_result + mult_result
    }
}


//# run 0xCAFE::NestedCalls::nested_call_adds --args 2u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
