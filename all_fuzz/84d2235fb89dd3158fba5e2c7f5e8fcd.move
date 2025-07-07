
//# publish
module 0xCAFE::Compute {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_example(): u8 {
        let add: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add(10, 20)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::UseCompute {
    use 0xCAFE::Compute;

    public fun call_add_then_return_sum(a: u8, b: u8): u8 {
        Compute::add_then_return_sum(a, b)
    }

    public fun call_lambda_example(): u8 {
        Compute::lambda_example()
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let temp = Compute::inline_add(a, b);
        Compute::add_then_return_sum(temp, 1u8)
    }
}


//# run 0xCAFE::Compute::add_then_return_sum --args 1u8 2u8


//# run 0xCAFE::Compute::lambda_example


//# run 0xCAFE::UseCompute::call_add_then_return_sum --args 5u8 10u8


//# run 0xCAFE::UseCompute::call_lambda_example


//# run 0xCAFE::UseCompute::nested_inline_call --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
