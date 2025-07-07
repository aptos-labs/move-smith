
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    // A function that adds two u8 values and returns the sum plus 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // A function that defines and uses a lambda to multiply and add values
    public fun lambda_operations(x: u8, y: u8): u8 {
        let lam: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            (p * q) + 5u8
        };
        lam(x, y)
    }

    // A runner function to test the above two functions with fixed values
    public fun runner(): (u8, u8) {
        let added = add_and_offset(4u8, 6u8);
        let lambda_result = lambda_operations(3u8, 7u8);
        (added, lambda_result)
    }
}


//# run 0xCAFE::AddAndLambda::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::lambda_operations --args 2u8 3u8


//# run 0xCAFE::AddAndLambda::runner



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    // Calls the inline add_and_offset function indirectly by calling runner() and returns the sum of both results
    public fun sum_all(): u8 {
        let (a, b) = AddAndLambda::runner();
        a + b
    }

    // Calls the add_and_offset with arbitrary values and adds result with lambda_operations result
    public fun combined_calls(x: u8, y: u8): u8 {
        let add_res = AddAndLambda::add_and_offset(x, y);
        let lam_res = AddAndLambda::lambda_operations(x, y);
        add_res + lam_res
    }

    // Runner for nested calls
    public fun runner(): (u8, u8) {
        let sum1 = sum_all();
        let sum2 = combined_calls(5u8, 8u8);
        (sum1, sum2)
    }
}


//# run 0xCAFE::NestedCalls::sum_all


//# run 0xCAFE::NestedCalls::combined_calls --args 7u8 8u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
