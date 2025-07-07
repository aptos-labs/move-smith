
//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambdas and returned values

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42
        } else {
            24
        }
    }

    public fun lambda_test(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let result = add_one(x);
        result
    }
}


//# run 0xCAFE::LambdaModule::add_two_values --args 5u8 6u8


//# run 0xCAFE::LambdaModule::lambda_test --args 10u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        // inline function returns sum
        a + b
    }

    public fun call_lambda_module_add(x: u8, y: u8): u8 {
        // calls LambdaModule::add_two_values which applies a condition to sum x+y
        LambdaModule::add_two_values(x, y)
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let inline_result = inline_add(x, y);
        let lambda_result = call_lambda_module_add(x, y);
        // total sum of both
        inline_result + lambda_result
    }
}


//# run 0xCAFE::NestedCallModule::call_lambda_module_add --args 4u8 5u8


//# run 0xCAFE::NestedCallModule::nested_calls --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
