
//# publish
module 0xCAFE::CalcAdd {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // returns sum + 10 to test a non-trivial computation
        sum + 10
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(6, 7)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }

    public fun inline_and_add(a: u8, b: u8): u8 {
        let doubled = inline_double(a);
        doubled + b
    }
}


//# publish
module 0xCAFE::CalcCaller {
    use 0xCAFE::CalcAdd;

    public fun call_add_and_process(x: u8, y: u8): u8 {
        let temp = CalcAdd::add_two_values(x, y);
        temp + 5
    }

    public fun run_lambda_in_calcadd(): u8 {
        CalcAdd::run_lambda_example()
    }

    public fun nested_inline_calls(x: u8, y: u8): u8 {
        let part1 = CalcAdd::inline_and_add(x, y);
        // Use inline_double explicitly again to test nested call
        let part2 = CalcAdd::inline_double(y);
        part1 + part2
    }
}


//# run 0xCAFE::CalcAdd::add_two_values --args 20u8 22u8


//# run 0xCAFE::CalcAdd::run_lambda_example


//# run 0xCAFE::CalcCaller::call_add_and_process --args 10u8 15u8


//# run 0xCAFE::CalcCaller::run_lambda_in_calcadd


//# run 0xCAFE::CalcCaller::nested_inline_calls --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
