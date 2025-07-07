
//# publish
module 0xCAFE::MathOperations {
    public fun add_and_return(a: u8, b: u8): u8 {
        let c = a + b;
        let _ = if (c == 0) { 0 } else { 1 };
        // Return c + 1 to test the addition and some extra logic
        c + 1
    }

    public fun lambda_example(x: u8): u8 {
        let add_one: |u8| u8 has copy+drop = |a: u8| {
            a + 1
        };
        add_one(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::MathOperations;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // call inline function from MathOperations module
        MathOperations::inline_add(a, b)
    }

    public fun lambda_caller(x: u8): u8 {
        let l: |u8| u8 has copy+drop = |y: u8| {
            MathOperations::add_and_return(y, 1)
        };
        l(x)
    }
}


//# run 0xCAFE::MathOperations::add_and_return --args 10u8 20u8


//# run 0xCAFE::MathOperations::lambda_example --args 41u8


//# run 0xCAFE::NestedCaller::call_inline_add --args 5u8 6u8


//# run 0xCAFE::NestedCaller::lambda_caller --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
