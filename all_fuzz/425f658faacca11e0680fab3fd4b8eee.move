
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and return a fixed u8 number if addition matches condition

    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::UseAddAndLambda {
    use 0xCAFE::AddAndLambda;

    public fun use_inline_add(a: u8, b: u8): u8 {
        AddAndLambda::inline_add(a, b)
    }

    public fun nested_call_and_check(a: u8, b: u8): u8 {
        let result = AddAndLambda::add_and_check(a, b);
        if (result == 42) {
            AddAndLambda::inline_add(a, b)
        } else {
            0u8
        }
    }
}


//# run 0xCAFE::AddAndLambda::add_and_check --args 4u8 6u8


//# run 0xCAFE::AddAndLambda::add_and_check --args 5u8 4u8


//# run 0xCAFE::AddAndLambda::run_lambda_example --args 7u8 3u8


//# run 0xCAFE::UseAddAndLambda::use_inline_add --args 8u8 9u8


//# run 0xCAFE::UseAddAndLambda::nested_call_and_check --args 4u8 6u8


//# run 0xCAFE::UseAddAndLambda::nested_call_and_check --args 1u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
