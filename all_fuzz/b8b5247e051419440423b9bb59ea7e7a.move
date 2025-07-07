
//# publish
module 0xCAFE::AddAndLambda {
    /// Adds two u8 values and then adds 10 to the result.
    public fun add_two_and_ten(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Returns a u8 result after applying a lambda that squares the input.
    public fun apply_lambda_square(x: u8): u8 {
        let squarer: |u8|u8 has copy+drop = |v: u8| { v * v };
        squarer(x)
    }

    /// Returns a u8 after applying two lambdas sequentially.
    public fun apply_lambdas_seq(x: u8): u8 {
        let inc: |u8|u8 has copy+drop = |v: u8| { v + 1 };
        let double: |u8|u8 has copy+drop = |v: u8| { v * 2 };
        let y = inc(x);
        double(y)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_and_ten --args 3u8 4u8


//# run 0xCAFE::AddAndLambda::apply_lambda_square --args 6u8


//# run 0xCAFE::AddAndLambda::apply_lambdas_seq --args 5u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    /// Calls AddAndLambda::add_two_and_ten and then applies a fixed adjust offset.
    public fun call_add_and_adjust(a: u8, b: u8): u8 {
        let base = AddAndLambda::add_two_and_ten(a, b);
        base + 5
    }

    /// Calls AddAndLambda::apply_lambda_square and then increases the result.
    public fun call_apply_lambda(x: u8): u8 {
        let squared = AddAndLambda::apply_lambda_square(x);
        squared + 1
    }

    /// Calls AddAndLambda::apply_lambdas_seq and returns the result directly.
    public fun call_apply_lambdas_seq(x: u8): u8 {
        AddAndLambda::apply_lambdas_seq(x)
    }
}


//# run 0xCAFE::NestedCalls::call_add_and_adjust --args 1u8 2u8


//# run 0xCAFE::NestedCalls::call_apply_lambda --args 4u8


//# run 0xCAFE::NestedCalls::call_apply_lambdas_seq --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4f3ebc2bf73d2b6b8e1ddee671d90213: Eliminate reference types in function parameters and result types to simplify type signatures.
