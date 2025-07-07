
//# publish
module 0xCAFE::ComputeAdd {
    // Module to test addition of two u8 values and return a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    public fun run_lambda_examples(): (u8, u8) {
        // Lambda that multiplies input by 2
        let double: |u8|u8 has copy + drop = |x: u8| {
            x * 2
        };
        // Lambda that adds 5 to input
        let add_five: |u8|u8 has copy + drop = |x: u8| {
            x + 5
        };
        let doubled = double(7u8);
        let plus_five = add_five(7u8);
        (doubled, plus_five)
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::ComputeAdd;

    // Call the inline function from ComputeAdd within this module
    public inline fun inline_increment(x: u8): u8 {
        x + 1u8
    }

    public fun call_compute_add_and_inline(a: u8, b: u8): (u8, u8) {
        let sum = ComputeAdd::add_and_return(a, b);
        let incremented = inline_increment(a);
        (sum, incremented)
    }
}


//# run 0xCAFE::ComputeAdd::add_and_return --args 12u8 34u8


//# run 0xCAFE::ComputeAdd::run_lambda_examples


//# run 0xCAFE::NestedCall::call_compute_add_and_inline --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
