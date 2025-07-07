
//# publish
module 0xCAFE::LambdaModule {
    // Lambda test module

    public fun add_two_values_and_return_specific_value(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda(x, y);

        // Return a specific value 42u8 if sum is greater than 20 else sum
        if (sum > 20u8) {
            42u8
        } else {
            sum
        }
    }

    public fun apply_lambda(x: u8, f: |u8| u8): u8 {
        f(x)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1u8
    }

    public fun test_inline_and_lambda(x: u8): u8 {
        let inc: |u8| u8 has copy+drop = |v: u8| {
            0xCAFE::LambdaModule::inline_increment(v)
        };
        apply_lambda(x, inc)
    }
}



//# run 0xCAFE::LambdaModule::add_two_values_and_return_specific_value --args 15u8 10u8

// Note: Passing a lambda as an argument through command line is not supported, so this run command is removed
// Instead, we test apply_lambda indirectly via test_inline_and_lambda as shown below


//# run 0xCAFE::LambdaModule::test_inline_and_lambda --args 41u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    public fun call_nested_inline(x: u8): u8 {
        // Calls LambdaModule::test_inline_and_lambda which calls the inline function
        LambdaModule::test_inline_and_lambda(x)
    }
}



//# run 0xCAFE::CallerModule::call_nested_inline --args 41u8
