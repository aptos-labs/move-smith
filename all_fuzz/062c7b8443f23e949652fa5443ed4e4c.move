
//# publish
module 0xCAFE::MathModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to have a specific value derived from sum
        sum + 10
    }

    public fun use_lambda_to_multiply_and_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let product = a * b;
            let sum = a + b;
            product + sum
        };
        lambda(x, y)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathModule;

    public inline fun inline_add_twice(x: u8): u8 {
        let a = MathModule::add_then_return_sum(x, 1);
        let b = MathModule::add_then_return_sum(a, 2);
        b
    }

    public fun runner(): u8 {
        inline_add_twice(5)
    }
}


//# run 0xCAFE::MathModule::add_then_return_sum --args 3u8 4u8


//# run 0xCAFE::MathModule::use_lambda_to_multiply_and_add --args 2u8 3u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
