
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed, specific value ignoring sum
        42u8
    }

    public fun add_lambda(): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add(10u8, 5u8)
    }
}


//# run 0xCAFE::Addition::add_and_return_special --args 7u8 8u8


//# run 0xCAFE::Addition::add_lambda


//# publish
module 0xCAFE::LambdaModule {
    public fun call_lambda_param(lambda: |u8, u8| u8, x: u8, y: u8): u8 {
        lambda(x, y)
    }

    public fun return_lambda(): |u8, u8| u8 has copy+drop {
        |a: u8, b: u8| { a + b }
    }

    public fun run_lambda_usage(): u8 {
        let l = return_lambda();
        call_lambda_param(l, 20u8, 22u8)
    }
}


//# run 0xCAFE::LambdaModule::run_lambda_usage


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Addition;

    public inline fun inline_add_twice(x: u8, y: u8): u8 {
        let first = Addition::add_lambda(); // sum 10+5=15
        let second = Addition::add_lambda(); // 15 again
        first + second + x + y // 15 + 15 + x + y
    }

    public fun call_nested_inline(x: u8, y: u8): u8 {
        inline_add_twice(x, y)
    }

    public fun runner(): u8 {
        call_nested_inline(1u8, 2u8)
    }
}


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
