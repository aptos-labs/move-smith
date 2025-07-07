
//# publish
module 0xCAFE::Adder {
    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun test_lambda_return_constant(): u8 {
        let lambda: |u8| u8 = |x: u8| {
            let _y = x + 5;
            42u8
        };
        lambda(3u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let sum_inline = inline_add(a, b);
        sum_inline + add_u8_values(a, b)
    }
}


//# run 0xCAFE::Adder::add_u8_values --args 3u8 4u8


//# run 0xCAFE::Adder::test_lambda_return_constant


//# run 0xCAFE::Adder::nested_inline_call --args 1u8 2u8



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_add(a: u8, b: u8): u8 {
        Adder::add_u8_values(a, b)
    }

    public fun call_nested_inline(a: u8, b: u8): u8 {
        Adder::nested_inline_call(a, b)
    }
}


//# run 0xCAFE::Caller::call_add --args 5u8 6u8


//# run 0xCAFE::Caller::call_nested_inline --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
