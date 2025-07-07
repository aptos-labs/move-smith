
//# publish
module 0xCAFE::Calc {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun lambda_add_and_multiply(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }

    public fun use_inline_and_lambda(x: u8, y: u8): u8 {
        let result = inline_double(x);
        let lambda: |u8| u8 has copy+drop = |n: u8| {
            n + y
        };
        let lambda_result = lambda(result);
        lambda_result
    }

    public fun return_in_expression(a: u8, b: u8): u8 {
        if (a > b) {
            return a
        } else {
            return b
        }
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun call_add_and_sum(): u8 {
        Calc::add_and_return_sum(5u8, 15u8)
    }

    public fun call_lambda_add_and_multiply(): (u8, u8) {
        Calc::lambda_add_and_multiply(3u8, 7u8)
    }

    public fun call_use_inline_and_lambda(): u8 {
        Calc::use_inline_and_lambda(4u8, 6u8)
    }

    public fun test_return_in_expression(): u8 {
        Calc::return_in_expression(10u8, 5u8)
    }
}


//# run 0xCAFE::Calc::add_and_return_sum --args 12u8 34u8


//# run 0xCAFE::Calc::lambda_add_and_multiply --args 6u8 8u8


//# run 0xCAFE::Calc::use_inline_and_lambda --args 5u8 7u8


//# run 0xCAFE::Calc::return_in_expression --args 9u8 11u8


//# run 0xCAFE::Caller::call_add_and_sum


//# run 0xCAFE::Caller::call_lambda_add_and_multiply


//# run 0xCAFE::Caller::call_use_inline_and_lambda


//# run 0xCAFE::Caller::test_return_in_expression


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// bb9fae4aff8bda84cdc6b8b4a25bc3c2: Use return statements in expressions
// f1d96b651080ac0705569fa50013eef4: Test the correct functioning of function calls, inline functions, and closures, including handling of parameters, tuples, and variable assignment.
