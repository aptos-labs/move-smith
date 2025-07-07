
//# publish
module 0xCAFE::AdditionModule {
    public fun add_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to test arithmetic and return
        sum + 1
    }

    public fun call_inline_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AdditionModule::add_values --args 10u8 20u8


//# run 0xCAFE::AdditionModule::call_inline_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_inc(x: u8): u8 {
        x + 1
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let sum = AdditionModule::add_values(a, b);
        let inc_sum = inline_inc(sum);
        inc_sum
    }

    public fun run_nested() {
        let _res = nested_calls(5u8, 6u8);
    }
}


//# run 0xCAFE::NestedCallModule::nested_calls --args 5u8 6u8


//# run 0xCAFE::NestedCallModule::run_nested


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
