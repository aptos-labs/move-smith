
//# publish
module 0xCAFE::AddAndReturn {
    /// Returns the sum of a and b, then returns fixed u8 value 42.
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // ignore `sum` except we want to test add
        42u8
    }

    /// Run a lambda that adds two u8 values and returns the result
    public fun run_lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }
}


//# run 0xCAFE::AddAndReturn::add_then_return --args 10u8 32u8


//# run 0xCAFE::AddAndReturn::run_lambda_add --args 11u8 7u8



//# publish
module 0xCAFE::CallInlineFromOther {
    use 0xCAFE::AddAndReturn;

    /// Calls AddAndReturn::run_lambda_add internally and adds 1 to the result
    public fun call_lambda_and_add_one(a: u8, b: u8): u8 {
        let val = AddAndReturn::run_lambda_add(a, b);
        val + 1u8
    }

    /// Calls AddAndReturn::add_then_return (which returns fixed 42) and adds 58 to result
    public fun call_add_then_return_and_add_58(a: u8, b: u8): u8 {
        let fixed_val = AddAndReturn::add_then_return(a, b);
        fixed_val + 58u8
    }
}


//# run 0xCAFE::CallInlineFromOther::call_lambda_and_add_one --args 20u8 21u8


//# run 0xCAFE::CallInlineFromOther::call_add_then_return_and_add_58 --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
