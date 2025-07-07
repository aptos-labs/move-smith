
//# publish
module 0xCAFE::Arithmetic {
    /// Returns the sum of two u8 numbers plus 5.
    public fun add_plus_five(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Returns a lambda that adds 10 to the input.
    public fun make_adder_10(): |u8| u8 {
        let adder = |x: u8| { x + 10 };
        adder
    }

    /// Applies a given lambda to the input value.
    public fun apply_lambda(f: |u8| u8, val: u8): u8 {
        f(val)
    }

    /// Calls an inline function from MyModule and returns a tuple.
    public fun call_my_module_inline(a: u16): (u16, u16) {
        0xCAFE::MyModule::f2(a)
    }

    // spec
    spec add_plus_five_spec(a: u8, b: u8) {
        let sum = a + b;
        let result = sum + 5;
    }
}




//# run 0xCAFE::Arithmetic::add_plus_five --args 1u8 2u8




//# run 0xCAFE::Arithmetic::make_adder_10




//# run 0xCAFE::Arithmetic::apply_lambda --args 7u8




//# run 0xCAFE::Arithmetic::call_my_module_inline --args 100u16




//# publish
module 0xCAFE::LambdaUser {
    /// Returns the result of applying a lambda that doubles its input.
    public fun use_lambda_double(): u8 {
        let doubler = |x: u8| { x * 2 };
        doubler(15u8)
    }

    /// Returns a lambda that adds two numbers, then applies it to given inputs.
    public fun apply_anonymous_lambda(a: u8, b: u8): u8 {
        let sum_lambda = |x: u8, y: u8| { x + y };
        let result = sum_lambda(a, b);
        result
    }

    // spec
    spec some_spec_variable {
        let dummy = 0;
    }
}




//# run 0xCAFE::LambdaUser::use_lambda_double




//# run 0xCAFE::LambdaUser::apply_anonymous_lambda --args 4u8 5u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c868117f86cbe0999fec1f937b40f129: End spec variable declarations with a semicolon in a spec block.
// 6b96d6915bf62b0b7ab660278c334d1e: Write non-native functions within target modules that will be checked by the compiler.
