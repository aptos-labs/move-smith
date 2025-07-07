
//# publish
module 0xCAFE::AddModule {
    const UNIQUE_ID: u64 = 0xABCDEF;

    public fun add_two_values_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            100u8
        }
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(2u8, 3u8)
    }
}


//# run 0xCAFE::AddModule::add_two_values_and_return_specific_value --args 5u8 8u8


//# run 0xCAFE::AddModule::lambda_example


//# publish
module 0xCAFE::NestedCallModule {
    const UNIQUE_ID: u64 = 0x123456;

    use 0xCAFE::AddModule;

    public fun nested_inline_calls(a: u16): (u16, u16) {
        // Call inline function from AddModule indirectly via AddModule::lambda_example (simulate nested calls)
        // Here we reuse MyModule example's f2 kind of inline function style by reimplementation
        // but we will call AddModule's lambda_example for simple test as part of nested behavior

        let result_lambda = AddModule::lambda_example();
        let (x, y) = inline_function_example(a);
        (x, y)
    }

    public inline fun inline_function_example(val: u16): (u16, u16) {
        (val + 10, val + 20)
    }
}


//# run 0xCAFE::NestedCallModule::nested_inline_calls --args 7u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c8c9da26e974ab1da16df200cc2f8521: Ensure each module has a unique identifier during compilation to prevent duplicate definitions.
