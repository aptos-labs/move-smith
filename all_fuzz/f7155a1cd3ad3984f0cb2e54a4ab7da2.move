
//# publish
module 0xCAFE::MyModule {
    // Define inline function f2 that returns a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        // For test purposes, let's return (x, x * 2)
        (x, x * 2)
    }
}

//# publish
module 0xCAFE::FunctionFeatures {
    // This module tests function calls and lambdas, including cross-module calls to inline functions.

    public fun add_then_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    public fun run_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let p = a * b;
            (s, p)
        };
        lambda(x, y)
    }

    // Calls inline function f2 from MyModule, extracts tuple, sums and returns
    public fun nested_inline_call(a: u16): u16 {
        let (v1, v2) = 0xCAFE::MyModule::f2(a);
        v1 + v2
    }

    // Runner for lambda function with fixed args
    public fun runner_lambda(): (u8, u8) {
        run_lambda(7u8, 8u8)
    }

    // Runner for add_then_return_special
    public fun runner_add(): u8 {
        add_then_return_special(5u8, 5u8)
    }

    // Runner for nested_inline_call
    public fun runner_inline(): u16 {
        nested_inline_call(100u16)
    }
}



//# run 0xCAFE::FunctionFeatures::runner_add



//# run 0xCAFE::FunctionFeatures::runner_lambda



//# run 0xCAFE::FunctionFeatures::runner_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
