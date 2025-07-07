
//# publish
module 0xCAFE::LambdaModule {
    // This module tests lambdas and inline function calls

    // Inline function that returns a simple transformation
    public inline fun add_one(x: u64): u64 {
        x + 1
    }

    // Function returning a lambda that adds two u8 numbers
    public fun get_adder_lambda(): |u8, u8|u8 has copy + drop {
        |a: u8, b: u8| {
            a + b
        }
    }

    // Function that returns a lambda which captures a variable from outer function
    public fun get_capturing_lambda(x: u8): |u8|u8 has copy + drop {
        |y: u8| { x + y }
    }

    // Nested lambdas: a lambda that returns another lambda
    public fun nested_lambdas(): |u8| (|u8|u8) has copy+drop {
        |a: u8| {
            |b: u8| { a + b }
        }
    }

    // Exercise nested lambdas and call them step by step
    public fun run_nested_lambda(): u8 {
        let outer = nested_lambdas();
        let inner = outer(10u8);
        inner(20u8)
    }

    // Function that calls the inline function from this module
    public fun call_inline(x: u64): u64 {
        add_one(x)
    }
}


//# run 0xCAFE::LambdaModule::get_adder_lambda


//# run 0xCAFE::LambdaModule::get_capturing_lambda --args 7u8


//# run 0xCAFE::LambdaModule::run_nested_lambda


//# run 0xCAFE::LambdaModule::call_inline --args 42u64


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaModule;

    // Call nested lambdas from LambdaModule and combine results
    public fun combine_nested_calls(): u8 {
        let adder = LambdaModule::get_adder_lambda();
        let capturing = LambdaModule::get_capturing_lambda(5u8);

        let sum1 = adder(10u8, 20u8);
        let sum2 = capturing(15u8);
        let nested_result = LambdaModule::run_nested_lambda();

        sum1 + sum2 + nested_result
    }

    // Call inline function from LambdaModule inside a user function
    public fun call_other_module_inline(x: u64): u64 {
        LambdaModule::call_inline(x)
    }

    // Runner function to test nested lambdas with manual invocation inside this module
    public fun test_nested_lambda_capture(): u8 {
        let outer_lambda = LambdaModule::nested_lambdas();
        let inner_lambda = outer_lambda(3u8);
        inner_lambda(7u8)
    }
}


//# run 0xCAFE::NestedCall::combine_nested_calls


//# run 0xCAFE::NestedCall::call_other_module_inline --args 100u64


//# run 0xCAFE::NestedCall::test_nested_lambda_capture


//# publish
module 0xCAFE::SpecUse {
    use std::vector;
    use 0xCAFE::LambdaModule;

    spec module {
        use 0xCAFE::LambdaModule;
        use std::vector;

        // Spec function using another module in spec context
        spec fun spec_call_inline(x: u64): u64 {
            LambdaModule::add_one(x)
        }
    }
}


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 816eaba9dee923083d4ed35c7da5bafb: Include 'use' directives within specification blocks to import modules or symbols.
// 81adbb1679cdd38eb72c44f7705f3e9c: Test that nested closures (lambdas) with various levels of nesting and captures are correctly type checked, invoked, and evaluated in the Aptos Move language.
