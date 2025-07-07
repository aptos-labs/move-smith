
//# publish
module 0xCAFE::MathModule {
    // A function to add two u8 values and then return a constant 42u8
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum;
        42u8
    }

    // A function with a lambda/anonymous function that doubles a u8 value and then adds 3
    public fun lambda_double_add(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| { v * 2 };
        let doubled = lambda(x);

        let add_three: |u8| u8 has copy+drop = |w: u8| { w + 3 };
        add_three(doubled)
    }

    // Inline function that returns triple of a u8 value
    public inline fun triple(x: u8): u8 {
        x * 3
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    // Call MathModule::add_and_return_constant with given values and return its result
    public fun call_add_and_return_constant(a: u8, b: u8): u8 {
        MathModule::add_and_return_constant(a, b)
    }

    // Call MathModule::lambda_double_add with given value and return result
    public fun call_lambda_double_add(x: u8): u8 {
        MathModule::lambda_double_add(x)
    }

    // Call the inline triple function from MathModule and return result
    public fun call_inline_triple(x: u8): u8 {
        MathModule::triple(x)
    }

    // Nested calls: call inline triple with the output of add_and_return_constant
    public fun nested_calls(a: u8, b: u8): u8 {
        let c = MathModule::add_and_return_constant(a, b);
        call_inline_triple(c)
    }
}


//# run 0xCAFE::MathModule::add_and_return_constant --args 10u8 15u8


//# run 0xCAFE::MathModule::lambda_double_add --args 7u8


//# run 0xCAFE::CallerModule::call_add_and_return_constant --args 20u8 22u8


//# run 0xCAFE::CallerModule::call_lambda_double_add --args 5u8


//# run 0xCAFE::CallerModule::call_inline_triple --args 9u8


//# run 0xCAFE::CallerModule::nested_calls --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
