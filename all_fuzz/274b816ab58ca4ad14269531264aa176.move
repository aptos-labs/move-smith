
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus a fixed offset 10 for testing
        sum + 10
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Arithmetic::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::Arithmetic::apply_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Arithmetic;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Arithmetic::inline_add(a, b)
    }

    public fun double_nested_call(a: u8, b: u8): u8 {
        let sum = call_inline_add(a, b);
        Arithmetic::add_and_return_sum(sum, 1u8)
    }

    public fun runner() {
        let _ = call_inline_add(2u8, 3u8);
        let _ = double_nested_call(4u8, 5u8);
    }
}


//# run 0xCAFE::NestedCaller::call_inline_add --args 10u8 15u8


//# run 0xCAFE::NestedCaller::double_nested_call --args 7u8 8u8


//# run 0xCAFE::NestedCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
