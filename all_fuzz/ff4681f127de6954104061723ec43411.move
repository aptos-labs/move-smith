
//# publish
module 0xCAFE::MathModule {
    // Simple function adding two u8 inputs, returns the sum plus a constant
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 42u8;
        result
    }

    // Function that uses a lambda to add two numbers and multiply by a constant
    public fun lambda_computation(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            (x + y) * 2u8
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::MathModule::add_and_return_constant --args 5u8 10u8


//# run 0xCAFE::MathModule::lambda_computation --args 5u8 6u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_and_math(a: u8, b: u8): u8 {
        let inc = inline_increment(a);
        let sum = MathModule::add_and_return_constant(inc, b);
        sum
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_math --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
