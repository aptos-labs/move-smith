
//# publish
module 0xCAFE::LambdaAndAdd {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2u8
        };
        lambda(x)
    }

    public fun add_and_apply_lambda(a: u8, b: u8): u8 {
        let sum = add_two_values(a, b);
        apply_lambda(sum)
    }
}


//# publish
module 0xCAFE::DeprecatedModule {
    public fun deprecated_function(): bool {
        true
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaAndAdd;

    public inline fun inline_return_u8(x: u8): u8 {
        x + 5u8
    }

    public fun call_inline_and_other(a: u8, b: u8): u8 {
        let partial = inline_return_u8(a);
        let total = LambdaAndAdd::add_two_values(partial, b);
        total
    }
}


//# run 0xCAFE::LambdaAndAdd::add_two_values --args 3u8 4u8


//# run 0xCAFE::LambdaAndAdd::apply_lambda --args 7u8


//# run 0xCAFE::LambdaAndAdd::add_and_apply_lambda --args 2u8 3u8


//# run 0xCAFE::NestedCalls::call_inline_and_other --args 1u8 2u8


//# run 0xCAFE::DeprecatedModule::deprecated_function


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 390b5dabfa1eded9d6a07449255a295e: Mark entire modules as deprecated with an annotation.
