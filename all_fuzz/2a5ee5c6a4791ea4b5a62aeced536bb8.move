
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 42) {
            100u8
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::LambdaCaller {
    use 0xCAFE::Adder;

    public fun call_lambda_directly(x: u8, y: u8): u8 {
        Adder::lambda_example(x, y)
    }

    public fun call_inline_from_another_module(a: u8, b: u8): u8 {
        Adder::inline_add(a, b)
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let inner_result = Adder::inline_add(a, b);
        // Use the inner result for another function call
        Adder::add_and_return_sum(inner_result, 5u8)
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::Adder::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Adder::lambda_example --args 10u8 15u8


//# run 0xCAFE::LambdaCaller::call_lambda_directly --args 7u8 8u8


//# run 0xCAFE::LambdaCaller::call_inline_from_another_module --args 15u8 20u8


//# run 0xCAFE::LambdaCaller::nested_inline_call --args 15u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
