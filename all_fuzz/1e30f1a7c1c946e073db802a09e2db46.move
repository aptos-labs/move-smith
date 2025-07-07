
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = 42u8;
        result
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |(u8, u8)| u8 has copy+drop = |(a, b): (u8, u8)| {
            a + b
        };
        lambda((x, y))
    }

    public fun nested_inline_call(x: u16): u32 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a as u32 + b as u32
    }
}


//# run 0xCAFE::LambdaTest::add_and_return --args 10u8 20u8


//# run 0xCAFE::LambdaTest::apply_lambda --args 15u8 26u8


//# run 0xCAFE::LambdaTest::nested_inline_call --args 5u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
