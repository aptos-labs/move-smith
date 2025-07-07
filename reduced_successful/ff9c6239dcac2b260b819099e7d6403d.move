
//# publish
module 0xCAFE::MathUtils {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun calculate_and_check(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        // Return a specific value if sum is even, else different value
        if ((sum % 2) == 0) {
            42u8
        } else {
            24u8
        }
    }

    public fun lambda_increment(x: u8): u8 {
        let inc: |u8|u8 has copy+drop = |v: u8| { v + 1 };
        inc(x)
    }

    public fun lambda_double_and_add(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { (a * 2) + b };
        f(x, y)
    }
}


//# run 0xCAFE::MathUtils::calculate_and_check --args 10u8 12u8


//# run 0xCAFE::MathUtils::calculate_and_check --args 7u8 4u8


//# run 0xCAFE::MathUtils::lambda_increment --args 41u8


//# run 0xCAFE::MathUtils::lambda_double_and_add --args 6u8 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathUtils;

    public fun call_add_u8(a: u8, b: u8): u8 {
        MathUtils::add_u8(a, b)
    }

    public fun call_calculate_and_check(a: u8, b: u8): u8 {
        MathUtils::calculate_and_check(a, b)
    }

    public fun call_lambda_increment(x: u8): u8 {
        MathUtils::lambda_increment(x)
    }

    public fun call_lambda_double_and_add(x: u8, y: u8): u8 {
        MathUtils::lambda_double_and_add(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_add_u8 --args 20u8 22u8


//# run 0xCAFE::CallerModule::call_calculate_and_check --args 15u8 14u8


//# run 0xCAFE::CallerModule::call_lambda_increment --args 99u8


//# run 0xCAFE::CallerModule::call_lambda_double_and_add --args 8u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
