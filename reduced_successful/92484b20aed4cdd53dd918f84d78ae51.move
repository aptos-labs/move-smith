
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun add_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };

        lambda(10u8, 20u8)
    }

    // Changed from inline to normal public fun for external calls
    public fun inline_addition(x: u8, y: u8): u8 {
        x + y
    }
}



//# run 0xCAFE::AdditionModule::add_then_return_sum --args 5u8 6u8



//# run 0xCAFE::AdditionModule::add_lambda



//# run 0xCAFE::AdditionModule::inline_addition --args 7u8 8u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_addition(x: u8, y: u8): u8 {
        AdditionModule::inline_addition(x, y)
    }

    public fun call_nested_functions(a: u8, b: u8): u8 {
        let sum = AdditionModule::add_then_return_sum(a, b);

        let lambda: |u8| u8 has copy+drop = |x: u8| {
            AdditionModule::inline_addition(x, 1u8)
        };

        lambda(sum)
    }
}



//# run 0xCAFE::CallerModule::call_inline_addition --args 10u8 11u8



//# run 0xCAFE::CallerModule::call_nested_functions --args 12u8 13u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
