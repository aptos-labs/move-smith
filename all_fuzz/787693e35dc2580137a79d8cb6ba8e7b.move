
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_example(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        // call the lambda with fixed values and return result
        add_lambda(7u8, 8u8)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_addition(a: u8, b: u8): u8 {
        AdditionModule::add_then_return_sum(a, b)
    }

    public fun call_lambda(): u8 {
        AdditionModule::lambda_example()
    }

    public fun call_inline_with_addition(a: u8): u8 {
        let incremented = AdditionModule::inline_increment(a);
        // sum with a fixed value, testing nested call with inline function
        let total = call_addition(incremented, 10u8);
        total
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_sum --args 123u8 45u8


//# run 0xCAFE::AdditionModule::lambda_example


//# run 0xCAFE::CallerModule::call_addition --args 11u8 22u8


//# run 0xCAFE::CallerModule::call_lambda


//# run 0xCAFE::CallerModule::call_inline_with_addition --args 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
