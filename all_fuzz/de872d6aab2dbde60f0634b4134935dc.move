
//# publish
module 0xCAFE::NestedCalls {
    use std::signer;

    public inline fun add_two(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_add_two(x: u8, y: u8): u8 {
        let sum = add_two(x, y);
        if (sum > 10) {
            42u8
        } else {
            43u8
        }
    }

    public fun call_lambda_with_addition(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let s = lambda(x, y);
        if (s > 10) {
            44u8
        } else {
            45u8
        }
    }
}


//# run 0xCAFE::NestedCalls::call_add_two --args 6u8 7u8


//# run 0xCAFE::NestedCalls::call_add_two --args 2u8 3u8


//# run 0xCAFE::NestedCalls::call_lambda_with_addition --args 8u8 5u8


//# run 0xCAFE::NestedCalls::call_lambda_with_addition --args 2u8 3u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::NestedCalls;

    public fun call_nested_addition(x: u8, y: u8): u8 {
        let added = NestedCalls::add_two(x, y);
        let result = NestedCalls::call_add_two(added, 1u8);
        result
    }
}


//# run 0xCAFE::CallerModule::call_nested_addition --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
