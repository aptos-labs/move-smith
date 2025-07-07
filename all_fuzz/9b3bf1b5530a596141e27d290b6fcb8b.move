
//# publish
module 0xCAFE::MathModule {
    // Test 1: function that computes addition of two u8 and returns a fixed value after that
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum;
        42u8
    }

    // Test 2: function containing lambda expressions (anonymous functions)
    public fun lambda_test(): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let multiply_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * y
        };
        let sum = add_lambda(5u8, 7u8);
        let product = multiply_lambda(3u8, 4u8);
        sum + product
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    // Test 3: call inline function from MathModule and also nested function calls
    public fun call_inline_and_sum(a: u8, b: u8, c: u8): u8 {
        let ab_sum = MathModule::inline_add(a, b);
        let abc_sum = MathModule::inline_add(ab_sum, c);
        abc_sum
    }
}


//# run 0xCAFE::MathModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::MathModule::lambda_test


//# run 0xCAFE::CallerModule::call_inline_and_sum --args 10u8 20u8 30u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
