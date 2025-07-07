
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_expression_example(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| {
            let s = a + b;
            s
        };
        let multiply = |a: u8, b: u8| {
            let p = a * b;
            p
        };
        let s = add(x, y);
        let p = multiply(x, y);
        (s, p)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 15u8 17u8


//# run 0xCAFE::AdditionModule::lambda_expression_example --args 3u8 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_fn(a: u16): (u16, u16) {
        (a, a + 5)
    }

    public fun call_inline_from_addition_module(x: u8, y: u8): u8 {
        let sum = AdditionModule::add_and_return_sum(x, y);
        let (a, b) = inline_fn(sum as u16);
        (a + b) as u8
    }
}


//# run 0xCAFE::CallerModule::call_inline_from_addition_module --args 10u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
