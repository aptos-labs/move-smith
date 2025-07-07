
//# publish
module 0xCAFE::AddU8 {
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 100) {
            42u8
        } else {
            100u8
        }
    }

    public fun with_lambda_showcase(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(10u8, 32u8);
        let another_lambda: |u8| u8 has copy+drop = |x: u8| {
            result + x
        };
        another_lambda(5u8)
    }
}



//# run 0xCAFE::AddU8::add_and_return_specific --args 12u8 30u8



//# run 0xCAFE::AddU8::with_lambda_showcase




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddU8;

    public inline fun inline_call_nested(a: u8, b: u8): u8 {
        // call AddU8::add_and_return_specific and add 1 to its result before returning
        let intermediate = AddU8::add_and_return_specific(a, b);
        intermediate + 1u8
    }

    public fun runner(): u8 {
        inline_call_nested(20u8, 30u8)
    }
}



//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
