
//# publish
module 0xCAFE::MathModule {
    // Module to test addition and inline function

    public fun add_and_return(input1: u8, input2: u8): u8 {
        let sum = input1 + input2;
        42u8 + sum
    }

    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambda expressions

    public fun run_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }

    public fun caller_lambda(): u8 {
        let fn_lambda: |u8| u8 has copy+drop = |x: u8| { x * 2 };
        fn_lambda(21u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let partial = MathModule::add_inline(a, b);
        partial + 3u8
    }

    public fun runner(): u8 {
        // call inline with fixed values
        call_inline_and_add(10u8, 20u8)
    }
}


//# run 0xCAFE::MathModule::add_and_return --args 5u8 10u8


//# run 0xCAFE::LambdaModule::run_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaModule::caller_lambda


//# run 0xCAFE::CallerModule::call_inline_and_add --args 7u8 8u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
