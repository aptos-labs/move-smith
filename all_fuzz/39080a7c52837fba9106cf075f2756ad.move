
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 200) {
            255
        } else {
            sum
        }
    }

    public fun lambda_apply_twice(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let first = add_lambda(x, y);
        let second = add_lambda(first, 1u8);
        second
    }

    public fun return_lambda(): |u8, u8| u8 has copy+drop {
        let multiply_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        multiply_lambda
    }
}


//# run 0xCAFE::Arithmetic::add_and_check --args 100u8 101u8


//# run 0xCAFE::Arithmetic::lambda_apply_twice --args 3u8 4u8


//# run 0xCAFE::Arithmetic::return_lambda


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Arithmetic;

    public fun call_inline_function(a: u8, b: u8): u8 {
        Arithmetic::add_and_check(a, b)
    }

    public fun nested_lambda_call(x: u8, y: u8): u8 {
        let lam = Arithmetic::return_lambda();
        lam(x, y)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_function --args 120u8 10u8


//# run 0xCAFE::InlineCaller::nested_lambda_call --args 7u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
