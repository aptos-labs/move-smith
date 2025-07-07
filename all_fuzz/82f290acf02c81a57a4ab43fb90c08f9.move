
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    public fun apply_lambda_and_return(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        let doubled = lambda(x);
        doubled
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1u8
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::AddModule::apply_lambda_and_return --args 15u8


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddModule;

    public fun call_inline_increment_and_add(x: u8, y: u8): u8 {
        let inc_x = AddModule::inline_increment(x);
        let sum = inc_x + y;
        sum
    }

    public fun runner(): u8 {
        call_inline_increment_and_add(5u8, 10u8)
    }
}


//# run 0xCAFE::CallInline::call_inline_increment_and_add --args 7u8 3u8


//# run 0xCAFE::CallInline::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
