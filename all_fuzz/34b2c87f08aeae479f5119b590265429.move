
//# publish
module 0xCAFE::LambdaAndInline {
    use std::vector;

    public inline fun inline_double(x: u8): u8 {
        x * 2u8
    }

    public fun apply_lambda_and_inline(x: u8): u8 {
        // lambda that adds 3 to input
        let adder: |u8|(u8) has copy+drop = |a: u8| {
            a + 3u8
        };
        let added = adder(x);

        // call inline function from this module to double the result
        let doubled = inline_double(added);

        // binary expression combining lambda result and inline function result
        let combined = added + doubled;

        combined
    }
}


//# run 0xCAFE::LambdaAndInline::apply_lambda_and_inline --args 5u8


//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::LambdaAndInline;

    public fun run_nested_calls(x: u8): u8 {
        // call lambda and inline function in LambdaAndInline module
        let val = LambdaAndInline::apply_lambda_and_inline(x);

        // apply binary operation on val from other module
        val * 3u8
    }
}


//# run 0xCAFE::CrossModuleCall::run_nested_calls --args 5u8


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// ff2ce72d7fe6ba162ce31d16f06cde76: Create binary or mutate expressions using two sub-expressions.
