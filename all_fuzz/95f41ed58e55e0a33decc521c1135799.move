
//# publish
module 0xCAFE::AddTest {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_adder(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(10u8, 20u8)
    }

    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddTest::add_then_return_sum --args 15u8 20u8


//# run 0xCAFE::AddTest::lambda_adder


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddTest;

    public fun call_inline_and_add(a: u8, b: u8, c: u8): u8 {
        let s = AddTest::inline_sum(a, b);
        s + c
    }
}


//# run 0xCAFE::CallInline::call_inline_and_add --args 1u8 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
