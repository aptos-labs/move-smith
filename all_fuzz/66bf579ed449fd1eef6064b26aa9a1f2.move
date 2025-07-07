
//# publish
module 0xCAFE::MathModule {
    // Module to test addition and inline functions with lambdas

    public fun add_u8_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Add 10 to sum and return
        sum + 10
    }

    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::MathModule::add_u8_values --args 3u8 4u8


//# run 0xCAFE::MathModule::apply_lambda --args 5u8 6u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let inline_sum = MathModule::inline_add(x, y);
        // Use add_u8_values from MathModule adding 10 to inline_sum and y
        MathModule::add_u8_values(inline_sum, y)
    }
}


//# run 0xCAFE::CallerModule::call_inline_and_add --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
