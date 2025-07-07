
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_five(a: u8, b: u8): u8 {
        let sum = a + b;
        // we ignore sum and return 5 to test computation and fixed return
        5u8
    }

    public fun run_lambda_example(x: u8): u8 {
        let multiply_by_two: |u8|u8 has copy+drop = |n: u8| {
            n * 2
        };
        multiply_by_two(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Adder::add_and_return_five --args 10u8 20u8


//# run 0xCAFE::Adder::run_lambda_example --args 7u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public fun call_inline_add_and_add_one(a: u8, b: u8): u8 {
        let sum = Adder::inline_add(a, b);
        sum + 1
    }

    public fun runner(): u8 {
        Self::call_inline_add_and_add_one(2u8, 3u8)
    }
}


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
