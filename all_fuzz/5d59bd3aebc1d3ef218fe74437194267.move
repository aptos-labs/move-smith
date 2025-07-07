
//# publish
module 0xCAFE::Addition {
    /// Returns sum of two u8 values plus 10.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun add_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(7u8, 8u8);
        result
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::Addition::add_and_offset --args 5u8 7u8


//# run 0xCAFE::Addition::add_lambda_example


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Addition;

    public fun add_via_nested_call(x: u8, y: u8): u8 {
        let base_sum = Addition::inline_adder(x, y);
        Addition::add_and_offset(base_sum, 1u8)
    }
}


//# run 0xCAFE::NestedCall::add_via_nested_call --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
