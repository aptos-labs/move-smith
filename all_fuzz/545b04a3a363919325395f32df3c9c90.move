
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 after computation
        42u8
    }

    public fun lambda_example(): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(10u8, 5u8)
    }
}


//# run 0xCAFE::Arithmetic::add_and_return --args 20u8 22u8


//# run 0xCAFE::Arithmetic::lambda_example



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Arithmetic;

    public inline fun inline_plus_one(x: u8): u8 {
        x + 1
    }

    public fun call_inline_and_lambda(a: u8, b: u8): (u8, u8) {
        let sum = Arithmetic::lambda_example();
        let plus_one = inline_plus_one(a);
        (sum, plus_one)
    }
}


//# run 0xCAFE::Caller::call_inline_and_lambda --args 41u8 0u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
