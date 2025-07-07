
//# publish
module 0xCAFE::AddModule {
    // This module provides a function to add two u8 numbers and return a fixed value on success

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // If sum less than 200 just return 99u8 otherwise return 100u8
        if (sum < 200u8) {
            99u8
        } else {
            100u8
        }
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 50u8  60u8


//# publish
module 0xCAFE::LambdaModule {
    // This module tests usage of lambda expressions inside Move functions

    public fun apply_lambda_twice(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 10u8
        };
        let y = lambda(x);
        let z = lambda(y);
        z
    }

    public fun compose_lambdas(x: u8): u8 {
        let inc: |u8|u8 has copy+drop = |a: u8| { a + 1u8 };
        let mul: |u8|u8 has copy+drop = |a: u8| { a * 2u8 };
        let composed: |u8|u8 has copy+drop = |a: u8| {
            let b = inc(a);
            mul(b)
        };
        composed(x)
    }
}


//# run 0xCAFE::LambdaModule::apply_lambda_twice --args 5u8


//# run 0xCAFE::LambdaModule::compose_lambdas --args 3u8


//# publish
module 0xCAFE::OuterModule {
    use 0xCAFE::AddModule;

    public fun nested_call_example(a: u8, b: u8): u8 {
        // Call AddModule::add_and_return_fixed
        let fixed_value = AddModule::add_and_return_fixed(a, b);
        // If fixed_value is 99u8 then call again with arguments 100, 120 else return 200
        if (fixed_value == 99u8) {
            let res = AddModule::add_and_return_fixed(100u8, 120u8);
            res
        } else {
            200u8
        }
    }
}


//# run 0xCAFE::OuterModule::nested_call_example --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
