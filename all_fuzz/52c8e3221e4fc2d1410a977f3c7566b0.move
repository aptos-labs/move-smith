
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = adder(a, b);
        sum
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(a: u16, b: u16): u16 {
        let c = a + b;
        c
    }

    public fun nested_inline_call(a: u16, b: u16): u8 {
        let intermediate = (a + b) as u8;
        // Call function in LambdaTest that adds two numbers and then adds 10
        let result = LambdaTest::add_then_return_sum(intermediate, 5u8);
        result
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_sum --args 10u8 20u8


//# run 0xCAFE::LambdaTest::use_lambda --args 15u8 25u8


//# run 0xCAFE::InlineCaller::nested_inline_call --args 10u16 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
