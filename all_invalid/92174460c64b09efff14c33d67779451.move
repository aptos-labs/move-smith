
//# publish
module 0xCAFE::MathLambda {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always end with semicolon for statement
        sum + 10
    }

    public fun lambda_double(x: u8): u8 {
        let double: |u8| u8 has copy+drop = |n: u8| { n * 2 };
        double(x)
    }

    public fun lambda_apply(f: |u8| u8, v: u8): u8 {
        f(v)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathLambda;

    public fun call_inline_increment_twice(x: u8): u8 {
        let a = MathLambda::inline_increment(x);
        let b = MathLambda::inline_increment(a);
        b
    }

    public fun call_lambda_double(x: u8): u8 {
        MathLambda::lambda_double(x)
    }

    public fun call_lambda_apply(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |n: u8| { n * 2 };
        MathLambda::lambda_apply(doubler, x)
    }
}


//# run 0xCAFE::MathLambda::add_and_return_sum --args 5u8 10u8


//# run 0xCAFE::MathLambda::lambda_double --args 7u8


//# run 0xCAFE::MathLambda::lambda_apply --args 9u8


//# run 0xCAFE::MathLambda::inline_increment --args 42u8


//# run 0xCAFE::CallerModule::call_inline_increment_twice --args 40u8


//# run 0xCAFE::CallerModule::call_lambda_double --args 6u8


//# run 0xCAFE::CallerModule::call_lambda_apply --args 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0303ed29a1e49f84c9479dc9458b0acb: Ensure code only uses features enabled by Move 2.0 to maintain compatibility.
