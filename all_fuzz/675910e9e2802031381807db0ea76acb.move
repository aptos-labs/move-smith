
//# publish
module 0xCAFE::AddAndLambda {
    // Test that a Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_then_return_value(a: u8, b: u8, final_value: u8): u8 {
        let sum = a + b;
        let _ = sum; // just computing sum to test addition, no assertion needed
        final_value
    }

    // Function containing a lambda (anonymous function) expression
    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
}


//# run 0xCAFE::AddAndLambda::add_then_return_value --args 10u8 20u8 99u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 5u8 7u8



//# publish
module 0xDEAD::InlineCalls {
    use 0xCAFE::AddAndLambda;

    // Inline function which calls an inline function from another module and returns the sum
    public inline fun inline_call_external(a: u8, b: u8): u8 {
        AddAndLambda::lambda_example(a, b) + 1
    }

    // Runner to test nested call
    public fun run_nested_call(): u8 {
        inline_call_external(3u8, 4u8)
    }
}


//# run 0xDEAD::InlineCalls::run_nested_call



//# publish
module 0xBEEF::VariedParams {
    // Function with varying number of parameters, returns sum of all
    public fun sum_three(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }

    public fun sum_no_params(): u8 {
        42
    }

    public fun sum_two_then_call_sum_three(a: u8, b: u8): u8 {
        sum_three(a, b, 1u8)
    }
}


//# run 0xBEEF::VariedParams::sum_three --args 1u8 2u8 3u8


//# run 0xBEEF::VariedParams::sum_no_params


//# run 0xBEEF::VariedParams::sum_two_then_call_sum_three --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2f4b7338562ca1cec5504769add511df: Specify the address for a module with the 'address' declaration.
// 4adf157cea6759d562aa3cd24a34a045: Test that the Move module correctly handles functions with varying parameters and call patterns by verifying their execution and return values across different scenarios.
