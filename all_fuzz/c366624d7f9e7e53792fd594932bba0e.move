
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_sum_plus_one(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    public fun create_lambda_adder(): |u8, u8| u8 {
        |a: u8, b: u8| {
            a + b
        }
    }

    public fun run_lambda_adder() {
        let adder = create_lambda_adder();
        let _result = adder(10u8, 15u8);
    }
}


//# run 0xCAFE::TestAdd::add_and_return_sum_plus_one --args 10u8 20u8


//# run 0xCAFE::TestAdd::run_lambda_adder



//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAdd;

    public inline fun multiply_by_two(x: u8): u8 {
        x * 2
    }

    public fun call_add_and_inline(x: u8, y: u8): u8 {
        let base = TestAdd::add_and_return_sum_plus_one(x, y);
        let multiplied = multiply_by_two(base);
        multiplied
    }
}


//# run 0xCAFE::TestInlineCall::call_add_and_inline --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
