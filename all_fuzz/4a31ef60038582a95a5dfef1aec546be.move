
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return the sum plus a constant 10
        sum + 10
    }

    public fun lambda_adder(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(7u8, 8u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return --args 7u8 5u8


//# run 0xCAFE::AdditionModule::lambda_adder


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let sum = AdditionModule::inline_add(a, b);
        // Add 5 to the result from inline_add and return
        sum + 5
    }

    public fun run_all(): u8 {
        let first = AdditionModule::add_and_return(3u8, 4u8);
        let second = lambda_runner();
        let third = call_inline_add(2u8, 3u8);
        // Return the sum of all three results
        first + second + third
    }

    public fun lambda_runner(): u8 {
        let my_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        my_lambda(4u8, 5u8)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 10u8 15u8


//# run 0xCAFE::CallerModule::lambda_runner


//# run 0xCAFE::CallerModule::run_all


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
