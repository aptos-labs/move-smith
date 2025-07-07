
//# publish
module 0xCAFE::CalcWithLambda {
    use std::signer;

    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun lambda_double(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        f(x)
    }

    public fun lambda_add_and_multiply(x: u8, y: u8): (u8, u8) {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        let mul: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        (add(x, y), mul(x, y))
    }
}


//# run 0xCAFE::CalcWithLambda::add_then_return --args 5u8 6u8


//# run 0xCAFE::CalcWithLambda::lambda_double --args 11u8


//# run 0xCAFE::CalcWithLambda::lambda_add_and_multiply --args 3u8 4u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcWithLambda;

    public fun cross_call_add_then_return(): u8 {
        CalcWithLambda::add_then_return(8u8, 5u8)
    }

    public fun cross_call_lambda_double(): u8 {
        CalcWithLambda::lambda_double(15u8)
    }

    public fun call_lambda_add_and_multiply(x: u8, y: u8): (u8, u8) {
        CalcWithLambda::lambda_add_and_multiply(x, y)
    }
}


//# run 0xCAFE::CallerModule::cross_call_add_then_return


//# run 0xCAFE::CallerModule::cross_call_lambda_double


//# run 0xCAFE::CallerModule::call_lambda_add_and_multiply --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
