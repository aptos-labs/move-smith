
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8 + sum
    }

    public fun add_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline_add_twice(x: u8, y: u8): u8 {
        let res1 = inline_add(x, y);
        let res2 = inline_add(res1, y);
        res2
    }
}


//# publish
module 0xCAFE::LambdaUser {
    use 0xCAFE::ComputeAdd;

    public fun use_lambda_and_inline(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            ComputeAdd::inline_add(a, b)
        };
        let sum_lambda = lambda(x, y);
        let sum_inline = ComputeAdd::call_inline_add_twice(x, y);
        sum_lambda + sum_inline
    }
}


//# run 0xCAFE::ComputeAdd::add_two --args 10u8 20u8


//# run 0xCAFE::ComputeAdd::add_with_lambda --args 5u8 7u8


//# run 0xCAFE::ComputeAdd::call_inline_add_twice --args 3u8 4u8


//# run 0xCAFE::LambdaUser::use_lambda_and_inline --args 2u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
