
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun lambda_add_then_multiply(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let multiply: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = add(x, y);
        let product = multiply(x, y);
        sum + product
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_lambda() {
        let result1 = AddModule::inline_add(10u8, 20u8);
        let result2 = AddModule::lambda_add_then_multiply(3u8, 4u8);
        let _sum_and_fixed = AddModule::add_and_return_fixed(7u8, 5u8);
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 5u8 7u8


//# run 0xCAFE::AddModule::lambda_add_then_multiply --args 2u8 3u8


//# run 0xCAFE::CallerModule::call_inline_and_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
