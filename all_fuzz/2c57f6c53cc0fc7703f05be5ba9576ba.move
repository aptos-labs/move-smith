
//# publish
module 0xCAFE::Calc {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun lambda_add_sub(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8| (u8) has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sub_lambda: |u8, u8| (u8) has copy+drop = |x: u8, y: u8| {
            if (x > y) { x - y } else { y - x }
        };

        let add_result = add_lambda(a, b);
        let sub_result = sub_lambda(a, b);
        (add_result, sub_result)
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun run_inline_add(a: u8, b: u8): u8 {
        let result = Calc::add_two_values(a, b);
        result + 5
    }
}


//# run 0xCAFE::Calc::add_two_values --args 7u8 8u8


//# run 0xCAFE::Calc::lambda_add_sub --args 15u8 5u8


//# run 0xCAFE::Caller::run_inline_add --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
