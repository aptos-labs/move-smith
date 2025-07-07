
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        // call add_and_return_sum inside caller module
        let sum = Adder::add_and_return_sum(x, y);

        // call call_lambda inside Adder module; tests nested calls and lambdas
        let lambda_result = Adder::call_lambda(sum, 10u8);

        lambda_result
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 5u8 12u8


//# run 0xCAFE::Adder::call_lambda --args 7u8 8u8


//# run 0xCAFE::Caller::call_inline_and_lambda --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// bf9d6723bbe3a98f8af6efcf0b0e836f: Write typed numeric literals directly as values, such as with a specific suffix.
