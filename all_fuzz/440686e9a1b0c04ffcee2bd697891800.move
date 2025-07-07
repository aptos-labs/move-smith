
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 to differentiate result
        sum + 10
    }

    public fun with_lambda(x: u8): u8 {
        let add_one: |u8|u8 has copy + drop = |n: u8| {
            n + 1
        };
        add_one(x)
    }
}


//# publish
module 0xCAFE::CallInlineFromOther {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_increment(x: u8): (u8, u8) {
        let a = AddAndLambda::add_and_return_sum(x, 1);
        let b = a + 1;
        (a, b)
    }

    public fun call_inline(x: u8): u8 {
        let (a, _b) = inline_increment(x);
        a
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_sum --args 20u8 30u8


//# run 0xCAFE::AddAndLambda::with_lambda --args 50u8


//# run 0xCAFE::CallInlineFromOther::call_inline --args 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
