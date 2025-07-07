
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun add_with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 10u8 32u8


//# run 0xCAFE::AdditionModule::add_with_lambda --args 12u8 25u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add_and_return(x: u8, y: u8): u8 {
        let result = AdditionModule::inline_addition(x, y);
        result
    }
}


//# run 0xCAFE::NestedCall::call_inline_add_and_return --args 40u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
