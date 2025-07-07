
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10, 20)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_from_another_module(x: u8, y: u8): u8 {
        let sum = Self::inline_add(x, y);
        sum + 5
    }

    public fun inline_accepts_closure_with_ignored_params(f: |u8, u8| u8, x: u8): u8 {
        f(x, 0)
    }

    public fun modify_local_variable_then_return(): u8 {
        let x = 5u8;
        x = x + 10;
        x
    }
}


//# publish
module 0xCAFE::UseAddAndReturn {
    use 0xCAFE::AddAndReturn;

    public fun run_callable_lambda(): u8 {
        AddAndReturn::lambda_example()
    }

    public fun call_inline_add_via_module(x: u8, y: u8): u8 {
        AddAndReturn::call_inline_from_another_module(x, y)
    }

    public fun use_inline_accepts_closure_with_ignored_params(x: u8): u8 {
        let closure: |u8, u8| u8 has copy+drop = |a: u8, _b: u8| {
            a + 2
        };
        AddAndReturn::inline_accepts_closure_with_ignored_params(closure, x)
    }

    public fun modify_local_and_return(): u8 {
        AddAndReturn::modify_local_variable_then_return()
    }
}


//# run 0xCAFE::AddAndReturn::add_then_return_sum --args 7u8 8u8


//# run 0xCAFE::AddAndReturn::lambda_example


//# run 0xCAFE::UseAddAndReturn::run_callable_lambda


//# run 0xCAFE::UseAddAndReturn::call_inline_add_via_module --args 15u8 5u8


//# run 0xCAFE::UseAddAndReturn::use_inline_accepts_closure_with_ignored_params --args 10u8


//# run 0xCAFE::UseAddAndReturn::modify_local_and_return


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 828d977b5d7b96456af4d7fd8c60f323: Test that inline functions can accept closures as arguments and properly handle closures with ignored parameters using underscores.
// 41a7e42786358f6234f852a8c37d00f0: Test that the function correctly modifies a local variable and returns the expected result without copying, ensuring move semantics are enforced.
