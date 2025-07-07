
//# publish
module 0xCAFE::CalcModule {
    const ANSWER: u8 = 42;

    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 50) {
            ANSWER
        } else {
            sum
        };
        ANSWER
    }

    public fun add_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_mult(x: u8, y: u8): u8 {
        x * y
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::CalcModule;

    public fun nested_call_example(x: u8, y: u8): u8 {
        let sum = CalcModule::add_lambda(x, y);
        let product = CalcModule::inline_mult(x, y);
        sum + product
    }
}


//# run 0xCAFE::CalcModule::add_and_return_special --args 20u8 25u8


//# run 0xCAFE::CalcModule::add_lambda --args 11u8 31u8


//# run 0xCAFE::NestedCallModule::nested_call_example --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 646d4127a24c340b4a97e5cc7f22b5a9: Define constants with specific names and values in Move modules.
