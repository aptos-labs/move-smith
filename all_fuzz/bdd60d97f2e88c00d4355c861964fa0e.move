
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100u8
        } else {
            sum
        };
        // last expression for return
        sum
    }

    public fun with_lambda(x: u8): u8 {
        let square: |u8|u8 has copy+drop = |a: u8| {
            a * a
        };
        square(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_from_here(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public fun test_nested_inline(a: u8, b: u8): u8 {
        LambdaTest::call_inline_from_here(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_u8 --args 10u8 20u8


//# run 0xCAFE::LambdaTest::with_lambda --args 7u8


//# run 0xCAFE::NestedCallTest::test_nested_inline --args 15u8 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
