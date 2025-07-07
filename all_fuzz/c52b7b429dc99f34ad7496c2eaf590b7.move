
//# publish
module 0xCAFE::Addition {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun use_lambda_and_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 = |x: u8, y: u8| { x + y };
        let sum = add_lambda(a, b);
        sum + 5u8
    }

    // An inline function that returns a u8 value
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b) + 2u8
    }
}


//# run 0xCAFE::Addition::add_two_numbers --args 3u8 7u8


//# run 0xCAFE::Addition::use_lambda_and_add --args 4u8 6u8


//# run 0xCAFE::Addition::call_inline_add --args 8u8 9u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Addition;

    public fun call_add_two_numbers(a: u8, b: u8): u8 {
        Addition::add_two_numbers(a, b)
    }

    public fun call_use_lambda_and_add(a: u8, b: u8): u8 {
        Addition::use_lambda_and_add(a, b)
    }

    public fun call_call_inline_add(a: u8, b: u8): u8 {
        Addition::call_inline_add(a, b)
    }

    // Runs all nested calls to test call paths
    public fun runner() {
        let _ = call_add_two_numbers(1u8, 2u8);
        let _ = call_use_lambda_and_add(2u8, 3u8);
        let _ = call_call_inline_add(3u8, 4u8);
    }
}


//# run 0xCAFE::NestedCaller::call_add_two_numbers --args 5u8 10u8


//# run 0xCAFE::NestedCaller::call_use_lambda_and_add --args 6u8 7u8


//# run 0xCAFE::NestedCaller::call_call_inline_add --args 7u8 8u8


//# run 0xCAFE::NestedCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0c909f7846db87c27a23716fc9e4e66b: Use inline annotation to suggest inlining Move functions.
