
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    // simple function that adds two u8 and returns the result plus a constant 42
    public fun add_plus_42(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 42
    }

    // function containing a lambda that multiplies two u8 values and returns the product plus 10
    public fun multiply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);
        product + 10u8
    }

    // Runner for add_plus_42
    public fun run_add_plus_42() {
        let _ = add_plus_42(3u8, 4u8);
    }

    // Runner for multiply_lambda
    public fun run_multiply_lambda() {
        let _ = multiply_lambda(2u8, 7u8);
    }
}


//# run 0xCAFE::AddAndLambda::run_add_plus_42


//# run 0xCAFE::AddAndLambda::run_multiply_lambda


//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::AddAndLambda;

    // call the inline add_plus_42 to test nested function call
    public fun nested_add_call(x: u8, y: u8): u8 {
        // call function in AddAndLambda module
        let result = AddAndLambda::add_plus_42(x, y);
        result
    }

    // also test inline function call inside this module
    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_nested_inline(x: u8): u8 {
        let incr_x = inline_increment(x);
        incr_x
    }

    public fun runner() {
        let _ = nested_add_call(5u8, 6u8);
        let _ = call_nested_inline(10u8);
    }
}


//# run 0xCAFE::InlineCallTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
