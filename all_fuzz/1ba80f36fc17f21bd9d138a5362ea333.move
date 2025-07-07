
//# publish
module 0xCAFE::AddModule {
    // Module to test addition and return specific value

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to give a specific output related to sum
        sum + 10
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::AddModule::call_lambda --args 8u8 9u8


//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::AddModule;

    public inline fun inline_add_twice(a: u8, b: u8): u8 {
        let intermediate = AddModule::add_and_return_sum(a, b);
        AddModule::add_and_return_sum(intermediate, a)
    }

    public fun runner(): u8 {
        inline_add_twice(3u8, 4u8)
    }
}


//# run 0xCAFE::CallInlineModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
