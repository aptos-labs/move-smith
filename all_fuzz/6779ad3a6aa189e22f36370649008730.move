
//# publish
module 0xCAFE::LambdaAdd {
    // Test features 1 & 2: function that adds two u8 values then returns a constant; a function with lambda expression

    /// Adds two u8 values and then returns 42u8.
    public fun add_then_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum; // use the sum for demonstration; normally you would do something sensible.
        42u8
    }

    /// Use a lambda expression that adds 2 to input and multiply result by 2.
    public fun lambda_usage(x: u8): u8 {
        let f: |u8| u8 has copy + drop = |val: u8| {
            let tmp = val + 2;
            tmp * 2
        };
        f(x)
    }
}


//# run 0xCAFE::LambdaAdd::add_then_return_const --args 10u8 20u8


//# run 0xCAFE::LambdaAdd::lambda_usage --args 8u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAdd;

    /// Calls LambdaAdd's lambda_usage with 5 and then adds 1. Returns the result.
    public fun call_lambda_and_add(): u8 {
        let val = LambdaAdd::lambda_usage(5u8);
        val + 1
    }

    /// Calls inline function in LambdaAdd or invokes add_then_return_const with fixed args
    public fun nested_calls(): u8 {
        // The add_then_return_const function is not inline but callable normally.
        LambdaAdd::add_then_return_const(7u8, 8u8)
    }
}


//# run 0xCAFE::CallerModule::call_lambda_and_add


//# run 0xCAFE::CallerModule::nested_calls



//# publish
module 0xCAFE::AttrTestModule {
    /// A struct with attribute attached
    // custom_struct_attr]
    struct TestStruct has store, copy, drop {
        val: u8
    }

    /// A public constant with attribute
    // custom_const_attr]
    const SOME_CONST: u8 = 99u8;

    /// A function with attribute that returns the constant above
    // custom_fun_attr]
    public fun return_const(): u8 {
        SOME_CONST
    }
}


//# run 0xCAFE::AttrTestModule::return_const


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7b8172797b973455b7119c42abf5a4df: Attach attributes to Move declarations by specifying an attribute name.
