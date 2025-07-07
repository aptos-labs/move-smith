
//# publish
module 0xCAFE::NestedCalls {
    public inline fun add_one(a: u8): u8 {
        a + 1
    }

    public fun call_add_one_twice(x: u8): u8 {
        let y = add_one(x);
        add_one(y)
    }
}


//# publish
module 0xCAFE::LambdaAndArith {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::NestedCalls;

    public fun call_nested_add(x: u8): u8 {
        NestedCalls::call_add_one_twice(x)
    }
}


//# run 0xCAFE::LambdaAndArith::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::LambdaAndArith::use_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_nested_add --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
