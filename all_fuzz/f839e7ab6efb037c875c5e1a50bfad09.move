
//# publish
module 0xCAFE::CalcAdd {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum < 10) {
            sum * 2
        } else {
            sum + 10
        };
        result
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::CalcAdd::add_two_values --args 4u8 5u8


//# run 0xCAFE::CalcAdd::add_two_values --args 7u8 8u8


//# run 0xCAFE::CalcAdd::add_with_lambda --args 9u8 1u8


//# publish
module 0xCAFE::UseInline {
    use 0xCAFE::CalcAdd;

    public inline fun call_inline_add(a: u8, b: u8): u8 {
        let inner_result = CalcAdd::add_two_values(a, b);
        inner_result + 1
    }

    public fun runner() {
        let _ = call_inline_add(3u8, 4u8);
        let _ = call_inline_add(10u8, 20u8);
    }
}


//# run 0xCAFE::UseInline::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
