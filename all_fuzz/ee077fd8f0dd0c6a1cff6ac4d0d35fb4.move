
//# publish
module 0xCAFE::MathModule {
    /// Adds two u8 values and then increases the result by 1.
    public fun add_then_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    /// Returns the result of applying a lambda that multiplies input by 2, then adds 5.
    public fun apply_lambda_and_add(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| { a * 2 };
        let doubled = lambda(x);
        doubled + 5
    }

    /// Returns the doubled value by applying the lambda to the input.
    public fun just_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| { a * 2 };
        lambda(x)
    }
}


//# publish
module 0xCAFE::OuterModule {
    use 0xCAFE::MathModule;

    /// Calls MathModule.add_then_increment and returns its result.
    public fun call_add_then_increment(x: u8, y: u8): u8 {
        MathModule::add_then_increment(x, y)
    }

    /// Calls MathModule.just_lambda and then adds 3 to the result.
    public fun call_just_lambda_and_add(x: u8): u8 {
        let doubled = MathModule::just_lambda(x);
        doubled + 3
    }

    /// Calls the lambda function (apply_lambda_and_add) in MathModule with argument 4.
    public fun call_apply_lambda_and_add(): u8 {
        MathModule::apply_lambda_and_add(4u8)
    }
}


//# run 0xCAFE::MathModule::add_then_increment --args 10u8 20u8


//# run 0xCAFE::MathModule::apply_lambda_and_add --args 7u8


//# run 0xCAFE::MathModule::just_lambda --args 8u8


//# run 0xCAFE::OuterModule::call_add_then_increment --args 5u8 6u8


//# run 0xCAFE::OuterModule::call_just_lambda_and_add --args 10u8


//# run 0xCAFE::OuterModule::call_apply_lambda_and_add


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
