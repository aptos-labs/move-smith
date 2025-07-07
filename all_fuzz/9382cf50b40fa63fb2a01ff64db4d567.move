
//# publish
module 0xCAFE::AddAndLambda {
    use std::vector;

    /// Adds two u8 numbers and returns their sum plus a constant offset 10
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Return a lambda that takes a u8 and adds 5 to it
    public fun get_adder_lambda(): |u8|u8 has copy+drop {
        |x: u8| {
            let res = x + 5;
            res
        }
    }

    /// Applies a given lambda on argument y
    public fun apply_lambda(f: |u8|u8, y: u8): u8 {
        f(y)
    }

    /// Runner function to test lambdas internally
    public fun runner_lambda(): u8 {
        let lambda = get_adder_lambda();
        apply_lambda(lambda, 20u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_with_offset --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::runner_lambda



//# publish
module 0xCAFE::NestedInlineCalls {
    use 0xCAFE::AddAndLambda;

    /// Calls the add_with_offset function from AddAndLambda module and returns its result multiplied by 2
    public fun nested_call(a: u8, b: u8): u8 {
        let base = AddAndLambda::add_with_offset(a, b);
        base * 2
    }

    /// Calls the runner_lambda from AddAndLambda and adds 1 to the result
    public fun call_lambda_runner(): u8 {
        let val = AddAndLambda::runner_lambda();
        val + 1
    }
}


//# run 0xCAFE::NestedInlineCalls::nested_call --args 3u8 4u8


//# run 0xCAFE::NestedInlineCalls::call_lambda_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
