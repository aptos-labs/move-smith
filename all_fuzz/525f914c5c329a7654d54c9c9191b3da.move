
//# publish
module 0xCAFE::NestedInline {
    public inline fun add_one(x: u8): u8 {
        x + 1
    }

    public fun sum_two_numbers(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_increment(a: u8, b: u8): u8 {
        let sum = sum_two_numbers(a, b);
        add_one(sum)
    }
}


//# publish
module 0xCAFE::LambdaExamples {
    public fun double_and_increment(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            let doubled = a + a;
            doubled + 1
        };
        lambda(x)
    }

    public fun apply_lambda_with_capture(x: u8): u8 {
        let base = 5;
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + base
        };
        lambda(x)
    }
}


//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::NestedInline;

    public fun nested_compute(x: u8, y: u8): u8 {
        NestedInline::compute_and_increment(x, y)
    }
}


//# run 0xCAFE::NestedInline::sum_two_numbers --args 10u8 20u8


//# run 0xCAFE::NestedInline::compute_and_increment --args 10u8 20u8


//# run 0xCAFE::LambdaExamples::double_and_increment --args 7u8


//# run 0xCAFE::LambdaExamples::apply_lambda_with_capture --args 10u8


//# run 0xCAFE::CrossModuleCall::nested_compute --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
