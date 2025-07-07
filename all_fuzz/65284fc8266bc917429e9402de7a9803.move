
//# publish
module 0xCAFE::AdditionModule {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let _sum = add_u8(a, b);
        42u8
    }

    public fun runner_add(): u8 {
        add_then_return_fixed(5u8, 10u8)
    }
}


//# run 0xCAFE::AdditionModule::runner_add



//# publish
module 0xCAFE::LambdaModule {
    public fun run_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    public fun runner_lambda(): (u8, u8) {
        run_lambda(3u8, 7u8)
    }
}


//# run 0xCAFE::LambdaModule::runner_lambda



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add_plus_one(x: u8, y: u8): u8 {
        let sum = AdditionModule::add_u8(x, y);
        sum + 1
    }

    public fun call_inline_add_plus_one(x: u8, y: u8): u8 {
        inline_add_plus_one(x, y)
    }

    public fun runner_nested(): u8 {
        call_inline_add_plus_one(20u8, 21u8)
    }
}


//# run 0xCAFE::NestedCallModule::runner_nested


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
