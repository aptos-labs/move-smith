
//# publish
module 0xCAFE::AddModule {
    public fun add_u8_and_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum // return sum+42 to check addition + constant return
    }

    public fun with_lambda_operations(a: u8, b: u8): (u8, u8) {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let prod_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        (sum_lambda(a, b), prod_lambda(a, b))
    }
}


//# run 0xCAFE::AddModule::add_u8_and_return_const --args 10u8 20u8


//# run 0xCAFE::AddModule::with_lambda_operations --args 7u8 8u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    public inline fun inline_call_example(x: u8, y: u8): u8 {
        // Call AddModule::add_u8_and_return_const inside an inline function
        let res = AddModule::add_u8_and_return_const(x, y);
        res * 2
    }

    public fun runner(): u8 {
        inline_call_example(5u8, 15u8)
    }
}


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
