
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun simple_lambda_example(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |v: u8| { v + 1 };
        add_one(x)
    }

    public fun nested_lambda_and_conditional(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            if (sum > 20) { 100 } else { sum }
        };
        lambda(x, y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::ComputeAdd;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let partial = ComputeAdd::add_and_return(x, y);
        let result = ComputeAdd::simple_lambda_example(partial);
        result
    }

    public inline fun inline_double(x: u8): u8 {
        x + x
    }

    public fun call_inline_twice(x: u8): u8 {
        let v = inline_double(x);
        inline_double(v)
    }
}


//# run 0xCAFE::ComputeAdd::add_and_return --args 5u8 6u8


//# run 0xCAFE::ComputeAdd::add_and_return --args 3u8 4u8


//# run 0xCAFE::ComputeAdd::simple_lambda_example --args 41u8


//# run 0xCAFE::ComputeAdd::nested_lambda_and_conditional --args 10u8 15u8


//# run 0xCAFE::CallerModule::call_inline_and_add --args 4u8 7u8


//# run 0xCAFE::CallerModule::call_inline_twice --args 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
