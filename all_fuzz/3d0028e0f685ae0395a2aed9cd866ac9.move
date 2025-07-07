
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            1u8
        }
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 5u8 6u8


//# publish
module 0xCAFE::LambdaTester {
    public fun run_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = add_lambda(x, y);
        let product = mul_lambda(x, y);

        if (sum > product) {
            sum
        } else {
            product
        }
    }
}


//# run 0xCAFE::LambdaTester::run_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedInline {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddAndReturn::add_and_return(a, b)
    }

    public fun call_inline_and_add(c: u8, d: u8): u8 {
        let result = inline_add(c, d);
        // Add 1 to the result to test nested calls and add
        result + 1u8
    }
}


//# run 0xCAFE::NestedInline::call_inline_and_add --args 6u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
