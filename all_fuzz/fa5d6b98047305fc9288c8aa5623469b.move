
//# publish
module 0xCAFE::AddAndLambda {
    // This module tests addition of u8 values and use of lambdas
    
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value after addition to test logic
        42u8
    }
    
    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
    
    // A function with an unused local variable to test compiler unused warning
    public fun unused_local_variable() {
        let _unused_var = 10u8;
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return --args 2u8 3u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 5u8 7u8


//# run 0xCAFE::AddAndLambda::unused_local_variable



//# publish
module 0xCAFE::UseInlineFunction {
    use 0xCAFE::AddAndLambda;

    // Inline function that calls the lambda using another module function
    public inline fun inline_call(x: u8, y: u8): u8 {
        let res = AddAndLambda::use_lambda(x, y);
        res
    }

    public fun runner() {
        let _ = inline_call(10u8, 20u8);
    }
}


//# run 0xCAFE::UseInlineFunction::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4cf1b5b548abbd8a56f796d3111f541a: Declare local variables in functions and have the compiler warn you if they are unused
