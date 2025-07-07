
//# publish
module 0xCAFE::ComputeModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun call_lambda_with_arg(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 5
        };
        lambda(x)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let result = 0xCAFE::ComputeModule::add_and_return_sum(x, y);
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            let inline_result = inline_fn(v);
            inline_result * 2
        };
        lambda(result)
    }

    public inline fun inline_fn(a: u8): u8 {
        a + 3
    }

    public fun utf8_string_examples() {
        let s1 = b"こんにちは";  // UTF-8 characters in byte string
        let s2 = b"Γειά σου Κόσμε"; // Greek UTF-8 characters
        let s3 = b"😊👍🏽"; // Emoji UTF-8 characters
    }
}


//# run 0xCAFE::ComputeModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::ComputeModule::call_lambda_with_arg --args 7u8


//# run 0xCAFE::ComputeModule::nested_call --args 4u8 6u8


//# run 0xCAFE::ComputeModule::utf8_string_examples


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4859f64d87e19222c0de459ca59e536f: Include UTF-8 encoded characters in string literals.
