
//# publish
module 0xCAFE::MathModule {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // return a fixed value 42 after addition (just for test)
        42u8
    }

    public fun call_lambda_twice(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 1
        };
        let first = lambda(x);
        let second = lambda(first);
        second
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathModule;

    public fun call_inline_add_from_other_module(x: u8, y: u8): u8 {
        let intermediate = MathModule::inline_add(x, y);
        MathModule::inline_add(intermediate, y)
    }

    public fun runner() {
        let _res1 = MathModule::add_then_return(10u8, 32u8);
        let _res2 = MathModule::call_lambda_twice(5u8);
        let _res3 = call_inline_add_from_other_module(3u8, 4u8);
    }
}


//# run 0xCAFE::MathModule::add_then_return --args 10u8 20u8


//# run 0xCAFE::MathModule::call_lambda_twice --args 3u8


//# run 0xCAFE::NestedCalls::call_inline_add_from_other_module --args 2u8 3u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
