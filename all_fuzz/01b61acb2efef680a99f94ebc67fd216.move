
//# publish
module 0xCAFE::CalcModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a constant after computing sum to test addition before return
        42
    }

    public fun lambda_test(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_adder(x: u8, y: u8): u8 {
        // call inline function from another module
        let result = CalcModule::inline_adder(x, y);
        result
    }

    public fun runner() {
        let _ = Self::call_inline_adder(7u8, 8u8);
        let _ = CalcModule::add_two_values(10u8, 20u8);
        let _ = CalcModule::lambda_test(15u8, 25u8);
    }
}


//# run 0xCAFE::CalcModule::add_two_values --args 3u8 4u8


//# run 0xCAFE::CalcModule::lambda_test --args 5u8 6u8


//# run 0xCAFE::NestedCallModule::call_inline_adder --args 10u8 20u8


//# run 0xCAFE::NestedCallModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
