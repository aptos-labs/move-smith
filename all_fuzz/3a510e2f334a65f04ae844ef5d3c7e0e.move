
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_given_value(a: u8, b: u8, return_value: u8): u8 {
        let sum = a + b;
        // We ignore sum and return the given fixed return_value instead
        return_value
    }

    public fun with_lambda_use() {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let _res = lambda(10u8, 20u8);
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Adder::add_and_return_given_value --args 5u8 10u8 42u8


//# run 0xCAFE::Adder::with_lambda_use


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Adder::inline_add(a, b)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let mid_result = Adder::inline_add(a, b);
        // Add 1 to the mid_result
        mid_result + 1
    }
}


//# run 0xCAFE::Caller::call_inline_add --args 15u8 25u8


//# run 0xCAFE::Caller::nested_call --args 20u8 30u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
