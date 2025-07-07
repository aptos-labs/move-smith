
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun lambda_add_then_multiply(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            sum + product
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 4u8 8u8


//# run 0xCAFE::AddModule::lambda_add_then_multiply --args 3u8 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public inline fun inline_caller(x: u8, y: u8): u8 {
        let sum = AddModule::add_and_return_fixed(x, y);
        let lambda_result = AddModule::lambda_add_then_multiply(x, y);
        sum + (lambda_result / 2)
    }

    public fun run_test(): u8 {
        inline_caller(7u8, 4u8)
    }
}


//# run 0xCAFE::CallerModule::run_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
