
//# publish
module 0xCAFE::Adder {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let c = a + b;
        // Return a fixed value after addition (e.g., 42) to test computation inside function
        42
    }

    public fun lambda_example(): u8 {
        let my_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        my_lambda(10u8, 20u8)
    }
}


//# run 0xCAFE::Adder::add_two_u8 --args 5u8 7u8


//# run 0xCAFE::Adder::lambda_example



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_from_another(): u8 {
        let sum = inline_add(3u8, 7u8);

        // Call the function from Adder module which returns fixed value 42
        let fixed_val = Adder::add_two_u8(1u8, 2u8);
        sum + fixed_val
    }
}


//# run 0xCAFE::NestedCall::call_inline_from_another


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
