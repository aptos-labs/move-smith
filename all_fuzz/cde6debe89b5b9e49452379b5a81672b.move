
//# publish
module 0xCAFE::AddLambdaModule {
    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) {
            10u8
        } else {
            sum
        };
        result
    }

    public fun lambda_expression_example(x: u8): u8 {
        let add_five_lambda: |u8|u8 has copy + drop = |n: u8| { n + 5 };
        add_five_lambda(x)
    }
}


//# run 0xCAFE::AddLambdaModule::add_two_u8_values --args 3u8 4u8


//# run 0xCAFE::AddLambdaModule::lambda_expression_example --args 7u8


//# publish
module 0xCAFE::NestedInlineCallModule {
    use 0xCAFE::AddLambdaModule;

    public inline fun inline_increment(n: u8): u8 {
        n + 1
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let sum = AddLambdaModule::add_two_u8_values(a, b);
        let incremented = inline_increment(sum);
        incremented
    }
}


//# run 0xCAFE::NestedInlineCallModule::nested_call --args 2u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
