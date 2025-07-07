
//# publish
module 0xCAFE::Arithmetic {
    public fun add_then_return(n1: u8, n2: u8): u8 {
        let sum = n1 + n2;
        // Always return 42 after addition
        42u8
    }

    public fun lambda_add_then_multiply(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }

    public fun apply_lambda_once(x: u8, func: |u8| u8): u8 {
        func(x)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Arithmetic;

    public inline fun double_increment_base(x: u8): u8 {
        let y = x + 1;
        let z = y + 1;
        z
    }

    public fun call_inline_and_lambda(x: u8): u8 {
        let inline_result = double_increment_base(x);
        let lambda_func: |u8| u8 has copy+drop = |y: u8| { y + 10 };
        let lambda_result = Arithmetic::apply_lambda_once(inline_result, lambda_func);
        lambda_result
    }
}


//# run 0xCAFE::Arithmetic::add_then_return --args 10u8 32u8


//# run 0xCAFE::Arithmetic::lambda_add_then_multiply --args 3u8 4u8


//# run 0xCAFE::NestedCalls::call_inline_and_lambda --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
