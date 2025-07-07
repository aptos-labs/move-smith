
//# publish
module 0xCAFE::CalcModule {
    public inline fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = add_two(a, b);
        42u8 + sum
    }

    public fun lambda_adder(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(20u8, 22u8)
    }
}


//# run 0xCAFE::CalcModule::add_and_return_specific --args 5u8 10u8


//# run 0xCAFE::CalcModule::lambda_adder



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::CalcModule;

    public fun nested_call_example(a: u8, b: u8): u8 {
        let sum = CalcModule::add_two(a, b);
        // Add 100 to distinguish from CalcModule output
        sum + 100u8
    }

    public fun call_inline_then_launch_lambda(): u8 {
        let intermediate = nested_call_example(1u8, 2u8);
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x * 2
        };
        lambda(intermediate)
    }
}


//# run 0xCAFE::NestedCallModule::nested_call_example --args 3u8 4u8


//# run 0xCAFE::NestedCallModule::call_inline_then_launch_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
