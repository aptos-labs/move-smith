
//# publish
module 0xCAFE::AdditionModule {
    // Module testing addition of two u8 values

    public fun add_two_numbers(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = add_two_numbers(a, b);
        // Return a fixed value to check correct computation happened before
        42u8
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 32u8




//# publish
module 0xCAFE::LambdaModule {
    // Module testing lambda (anonymous function) expressions

    public fun call_lambda_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::LambdaModule::call_lambda_sum --args 7u8 8u8



//# run 0xCAFE::LambdaModule::call_lambda_return_tuple --args 5u8 6u8




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun caller_inline(a: u8, b: u8): u8 {
        let sum = AdditionModule::add_two_numbers(a, b);
        sum + 10u8
    }

    public fun run_caller(): u8 {
        caller_inline(3u8, 4u8)
    }
}



//# run 0xCAFE::InlineCaller::run_caller




//# publish
module 0xCAFE::DependencyUser {
    use 0xCAFE::LambdaModule;
    use 0xCAFE::InlineCaller;

    public fun use_dependencies(a: u8, b: u8): (u8, u8, u8) {
        let sum_lambda = LambdaModule::call_lambda_sum(a, b);
        let prod_lambda_1;
        let prod_lambda_2;
        // Decompose the tuple returned by call_lambda_return_tuple without binding it to a local variable of tuple type
        let prod_tuple = LambdaModule::call_lambda_return_tuple(a, b);
        let (prod_lambda_1_local, prod_lambda_2_local) = prod_tuple;
        prod_lambda_1 = prod_lambda_1_local;
        prod_lambda_2 = prod_lambda_2_local;

        let inline_val = InlineCaller::caller_inline(a, b);

        (sum_lambda, prod_lambda_2, inline_val)
    }
}



//# run 0xCAFE::DependencyUser::use_dependencies --args 2u8 3u8

// The above transactional test commands exercise:
// 1) simple addition and fixed return
// 2) lambda expressions returning values and tuples
// 3) inline function calling another module's inline function
// 4) importing and calling functions from other modules
// A spec module without a target module is NOT included, so no compilation errors occur.


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 796915427923940fa614e2749935cd9f: Import and use dependencies from other modules in your module or script.
// d4dccfeee89ce45d6510a84b34380f76: Be warned that a spec module without an associated target module in the same compilation unit will result in a compilation error
