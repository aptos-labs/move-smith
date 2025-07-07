
//# publish
module 0xCAFE::NestedCalls {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_twice(a: u8, b: u8, c: u8): u8 {
        let first = inline_add(a, b);
        let second = inline_add(first, c);
        second
    }
}


//# publish
module 0xCAFE::LambdaExamples {
    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun apply_lambda_twice(x: u8, y: u8, z: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let first = lambda(x, y);
        let second = lambda(first, z);
        second
    }
}


//# publish
module 0xCAFE::ComputeAdd {
    use 0xCAFE::NestedCalls;

    public fun compute(a: u8, b: u8, c: u8): u8 {
        NestedCalls::call_inline_add_twice(a, b, c)
    }
}


//# run 0xCAFE::LambdaExamples::apply_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaExamples::apply_lambda_twice --args 3u8 4u8 5u8


//# run 0xCAFE::ComputeAdd::compute --args 3u8 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
