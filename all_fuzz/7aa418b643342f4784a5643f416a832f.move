
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == a + b) {
            42u8
        } else {
            0u8
        }
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }
}


//# run 0xCAFE::AdditionTest::add_and_return_constant --args 10u8 32u8


//# run 0xCAFE::AdditionTest::with_lambda --args 20u8 22u8


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AdditionTest;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let res1 = AdditionTest::add_and_return_constant(a, b);

        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            AdditionTest::with_lambda(x, y)
        };

        let res2 = lambda(a, b);

        if (res1 == 42 && res2 == a + b) {
            res2
        } else {
            0u8
        }
    }
}


//# run 0xCAFE::NestedCallTest::call_inline_and_lambda --args 15u8 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
