
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            1u8
        } else {
            0u8
        };
        // Explicit return of a constant to test return value correctness
        42u8
    }

    public fun test_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(7u8, 8u8);
        result
    }
}


//# run 0xCAFE::AdditionTest::add_and_check --args 4u8 5u8


//# run 0xCAFE::AdditionTest::test_lambda



//# publish
module 0xCAFE::NestedInline {
    use 0xCAFE::AdditionTest;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let sum = inline_adder(a, b);
        let result = AdditionTest::add_and_check(sum, 1u8);
        result
    }
}


//# run 0xCAFE::NestedInline::nested_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
