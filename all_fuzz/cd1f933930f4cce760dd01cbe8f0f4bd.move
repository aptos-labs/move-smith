
//# publish
module 0xCAFE::AddModule {
    // Test addition of two u8 values and return a fixed u8 value 42u8

    public fun add_and_return(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }

    public fun call_lambda_example(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v + 1u8
        };
        lambda(x)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1u8
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 10u8 32u8


//# run 0xCAFE::AddModule::call_lambda_example --args 41u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_increment(a: u8): u8 {
        AddModule::inline_increment(a)
    }

    public fun test_nested_calls(x: u8, y: u8): u8 {
        let sum = x + y;
        let incremented = call_inline_increment(sum);
        incremented
    }
}


//# run 0xCAFE::CallerModule::call_inline_increment --args 10u8


//# run 0xCAFE::CallerModule::test_nested_calls --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
