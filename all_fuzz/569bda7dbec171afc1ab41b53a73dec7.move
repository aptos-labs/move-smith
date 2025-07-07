
//# publish
module 0xCAFE::Calc {
    public fun add_then_add_five(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    public fun apply_lambda_and_add_five(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 10
        };
        let res = lambda(x);
        res + 5
    }
}


//# run 0xCAFE::Calc::add_then_add_five --args 10u8 20u8


//# run 0xCAFE::Calc::apply_lambda_and_add_five --args 5u8


//# publish
module 0xCAFE::UseInline {
    use 0xCAFE::Calc;

    // Inline function in this module calling inline function from Calc
    public inline fun nested_inline_addition(a: u8, b: u8): u8 {
        let sum = Calc::add_then_add_five(a, b);
        sum + 10
    }

    public fun nested_runner() {
        let result = nested_inline_addition(1u8, 2u8);
        let _ = result;
    }
}


//# run 0xCAFE::UseInline::nested_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
