
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_then_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambda_example(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |y: u8| { y + 1 };
        let result = add_one(x);
        result
    }

    public fun lambda_with_env_capture(): u8 {
        let base = 5u8;
        let add_base: |u8|u8 has copy+drop = |x: u8| { x + base };
        add_base(10)
    }
}


//# run 0xCAFE::AddAndLambda::add_then_check --args 4u8 6u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 7u8


//# run 0xCAFE::AddAndLambda::lambda_with_env_capture



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_add_twice(a: u8): u8 {
        let r1 = AddAndLambda::add_then_check(a, 1u8);
        let r2 = AddAndLambda::add_then_check(r1, 1u8);
        r2
    }

    public fun call_inline_twice(a: u8): u8 {
        inline_add_twice(a)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_twice --args 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
